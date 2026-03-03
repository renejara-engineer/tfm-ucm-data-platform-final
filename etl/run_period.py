# ======================================================
# run_period.py
# ======================================================
import argparse
import os
import re
import subprocess
import sys
from pathlib import Path

import psycopg

# ======================================================
# CONFIGURACIÓN GENERAL
# ======================================================

DATA_LAKE_ROOT = Path(os.getenv("DATA_LAKE_ROOT", "/data_lake"))
INBOX = DATA_LAKE_ROOT / "00_INBOX"

DB_CFG = {
    "host": os.getenv("DB_HOST", "chile-pg"),
    "port": int(os.getenv("DB_PORT", "5432")),
    "dbname": os.getenv("DB_NAME", "chilecompra"),
    "user": os.getenv("DB_USER", "chile_user"),
    "password": os.getenv("DB_PASS", ""),
}

# ======================================================
# UTILIDADES SISTEMA
# ======================================================

def run(cmd: str) -> None:
    p = subprocess.run(cmd, shell=True, text=True)
    if p.returncode != 0:
        raise RuntimeError(f"Command failed ({p.returncode}): {cmd}")

def db_scalar(sql: str) -> str:
    with psycopg.connect(**DB_CFG) as conn:
        with conn.cursor() as cur:
            cur.execute(sql)
            row = cur.fetchone()
            return "" if row is None or row[0] is None else str(row[0])

def db_exec(sql: str) -> None:
    with psycopg.connect(**DB_CFG) as conn:
        with conn.cursor() as cur:
            cur.execute(sql)
        conn.commit()

# ======================================================
# VALIDACIONES BÁSICAS
# ======================================================

def ensure_period(period: str) -> str:
    if not re.fullmatch(r"\d{4}-\d{2}", period):
        raise ValueError("Formato inválido. Use YYYY-MM.")
    return period

def idempotent_ok(entidad: str, periodo: str) -> bool:
    sql = f"""
        SELECT 1
        FROM dw.etl_control_cargas
        WHERE entidad='{entidad}'
          AND periodo='{periodo}'
          AND estado='OK'
        LIMIT 1;
    """
    return db_scalar(sql) == "1"

# ======================================================
# CONTROL ETL
# ======================================================

def upsert_control(entidad: str, periodo: str, estado: str,
                   archivo: str, filas_stg: int, filas_dw: int) -> None:
    sql = f"""
    INSERT INTO dw.etl_control_cargas
        (entidad, periodo, estado, archivo, filas_stg, filas_dw, ts_fin)
    VALUES
        ('{entidad}', '{periodo}', '{estado}', '{archivo}',
         {filas_stg}, {filas_dw}, now())
    ON CONFLICT (entidad, periodo) DO UPDATE SET
        estado     = EXCLUDED.estado,
        archivo    = EXCLUDED.archivo,
        filas_stg  = EXCLUDED.filas_stg,
        filas_dw   = EXCLUDED.filas_dw,
        ts_fin     = EXCLUDED.ts_fin;
    """
    db_exec(sql)

# ======================================================
# INBOX
# ======================================================

def inbox_paths(period: str):
    lic = INBOX / "LIC" / period / f"LIC_{period}.csv"
    oc  = INBOX / "OC"  / period / f"OC_{period}.csv"
    return lic, oc

# ======================================================
# CONTADORES
# ======================================================

def count_stg(table: str) -> int:
    return int(db_scalar(f"SELECT count(*) FROM stg.{table};"))

def count_dw(table: str, period: str) -> int:
    return int(db_scalar(
        f"SELECT count(*) FROM {table} WHERE periodo='{period}';"
    ))

def sentinel_oc(period: str) -> int:
    return int(db_scalar(
        f"""
        SELECT count(*)
        FROM dw.fact_ordenes_compra
        WHERE periodo='{period}'
          AND monto_total >= 999000000000000;
        """
    ))

# ======================================================
# SQL TEMPLATES
# ======================================================

def render_template(filename: str, period: str, tag: str) -> str:
    tpl_path = Path(__file__).resolve().parent / "sql_templates" / filename
    txt = tpl_path.read_text(encoding="utf-8")
    return txt.replace("{{period}}", period).replace("{{tag}}", tag)

# ======================================================
# BLINDAJE DEFINITIVO STG (CLAVE)
# ======================================================

def ensure_stg_columns(schema: str, table: str, required_columns: dict) -> None:
    """
    Garantiza que la tabla STG tenga las columnas mínimas
    requeridas por el SQL de negocio.
    """
    for col, col_type in required_columns.items():
        db_exec(f"""
            ALTER TABLE {schema}.{table}
            ADD COLUMN IF NOT EXISTS {col} {col_type};
        """)

# ======================================================
# MAIN
# ======================================================

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--period", required=True)
    args = ap.parse_args()

    period = ensure_period(args.period)
    tag = period.replace("-", "_")

    lic_csv, oc_csv = inbox_paths(period)

    if not lic_csv.exists() or lic_csv.stat().st_size == 0:
        print(f"[ERROR] Falta LIC CSV: {lic_csv}", file=sys.stderr)
        return 2

    if not oc_csv.exists() or oc_csv.stat().st_size == 0:
        print(f"[ERROR] Falta OC CSV: {oc_csv}", file=sys.stderr)
        return 2

    # Idempotencia total
    if idempotent_ok("LIC", period) and idempotent_ok("OC", period):
        print(f"[SKIP] {period} ya OK en dw.etl_control_cargas.")
        return 0

    try:
        # ==================================================
        # 1) STG mensual desde INBOX
        # ==================================================
        run(f"python /app/cli_monthly.py --period {period}")

        stg_lic = f"stg_lic_{tag}"
        stg_oc  = f"stg_oc_{tag}"

        # ==================================================
        # 2) BLINDAJE STG (PUNTO CLAVE)
        # ==================================================
        ensure_stg_columns(
            schema="stg",
            table=stg_lic,
            required_columns={
                "codigoexterno": "text"
            }
        )

        db_exec(f"""
            UPDATE stg.{stg_lic}
            SET codigoexterno = COALESCE(codigoexterno, '');
        """)

        # ==================================================
        # 3) Dimensión fecha (idempotente)
        # ==================================================
        if os.getenv("DIM_FECHA_MODE", "db_init").lower() == "etl":
            run(f"python /app/dw/load_dim_fecha.py --period {period}")
        else:
            print("[INFO] dim_fecha: using db/init seed (DIM_FECHA_MODE!=etl)")

        # ==================================================
        # 4) Gate2 DW (dims)  <<<< FIX facts=0
        # ==================================================
        # print("[INFO] Gate2: ejecutando dims (organismo/proveedor/producto_onu)")
        db_exec(render_template("gate2_dim_organismo.template.sql", period, tag))
        db_exec(render_template("gate2_dim_proveedor.template.sql", period, tag))
        db_exec(render_template("gate2_dim_producto_onu.template.sql", period, tag))
        print("[OK] Gate2 dims ejecutado")


        # ==================================================
        # 4) Gate3 DW (facts)
        # ==================================================
        db_exec(render_template(
            "gate3_fact_licitaciones.template.sql", period, tag
        ))

        db_exec(render_template(
            "gate3_fact_ordenes_compra_v2.template.sql", period, tag
        ))

        # ==================================================
        # 5) Métricas
        # ==================================================
        filas_stg_lic = count_stg(stg_lic)
        filas_stg_oc  = count_stg(stg_oc)

        filas_dw_lic = count_dw("dw.fact_licitaciones", period)
        filas_dw_oc  = count_dw("dw.fact_ordenes_compra", period)

        # ==================================================
        # 6) Validación semántica OC
        # ==================================================
        if sentinel_oc(period) != 0:
            upsert_control("OC", period, "FAILED",
                           f"OC_{period}.csv", filas_stg_oc, filas_dw_oc)
            print(f"[ERROR] Sentinel OC activado {period}", file=sys.stderr)
            return 3

        # ==================================================
        # 7) Control final
        # ==================================================
        upsert_control(
            "LIC", period,
            "OK" if filas_dw_lic > 0 else "FAILED",
            f"LIC_{period}.csv", filas_stg_lic, filas_dw_lic
        )

        upsert_control(
            "OC", period,
            "OK" if filas_dw_oc > 0 else "FAILED",
            f"OC_{period}.csv", filas_stg_oc, filas_dw_oc
        )

        print(f"[OK] ETL periodo {period} finalizado correctamente.")
        return 0

    except Exception as e:
        print(f"[FAILED] {period}: {e}", file=sys.stderr)
        return 4

if __name__ == "__main__":
    raise SystemExit(main())
