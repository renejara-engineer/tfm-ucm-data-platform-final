# 0 - IMPORTS Y CONFIG
import argparse
import os
from datetime import date, timedelta
import psycopg2
from psycopg2.extras import execute_batch

# 1 - PARSEO DE ARGUMENTOS
def parse_args():
    p = argparse.ArgumentParser(description="Carga idempotente dw.dim_fecha por periodo (YYYY-MM)")
    p.add_argument("--periodo", required=True, help="Periodo en formato YYYY-MM (ej: 2024-10)")
    return p.parse_args()

# 2 - RANGO DE FECHAS DESDE PERIODO
def periodo_to_range(periodo: str):
    y, m = map(int, periodo.split("-"))
    start = date(y, m, 1)
    if m == 12:
        end = date(y + 1, 1, 1) - timedelta(days=1)
    else:
        end = date(y, m + 1, 1) - timedelta(days=1)
    return start, end

# 3 - CONEXION ROBUSTA (LEE DB_* DEL docker-compose; FALLBACK A POSTGRES_*)
def get_conn():
    # Preferencia: variables del servicio ETL (docker-compose.yml)
    host = os.getenv("DB_HOST") or os.getenv("POSTGRES_HOST") or "chile-pg"
    port = os.getenv("DB_PORT") or os.getenv("POSTGRES_PORT") or "5432"
    db   = os.getenv("DB_NAME") or os.getenv("POSTGRES_DB") or "chilecompra"
    user = os.getenv("DB_USER") or os.getenv("POSTGRES_USER") or "chile_user"
    pwd  = os.getenv("DB_PASS") or os.getenv("POSTGRES_PASSWORD") or ""

    # Validación dura: si no hay password, abortar con mensaje claro
    if not pwd:
        raise RuntimeError(
            "Falta password de Postgres. Se esperaba DB_PASS o POSTGRES_PASSWORD en el contenedor ETL."
        )

    return psycopg2.connect(host=host, port=port, dbname=db, user=user, password=pwd)

# 4 - GENERACION DE FILAS CALENDARIO (ALINEADO A TU DDL)
def build_rows(start: date, end: date):
    rows = []
    d = start
    while d <= end:
        anio = d.year
        mes = d.month
        dia = d.day
        trimestre = ((mes - 1) // 3) + 1
        nombre_mes = d.strftime("%B")
        nombre_dia_semana = d.strftime("%A")
        es_fin_de_semana = (d.weekday() >= 5)

        rows.append((
            d,
            anio,
            mes,
            dia,
            trimestre,
            nombre_mes,
            nombre_dia_semana,
            es_fin_de_semana
        ))
        d += timedelta(days=1)
    return rows

# 5 - CARGA IDEMPOTENTE (NO INSERTA fecha_sk; usa UNIQUE(fecha))
def load_dim_fecha(conn, rows):
    sql = """
    INSERT INTO dw.dim_fecha (
        fecha,
        anio,
        mes,
        dia,
        trimestre,
        nombre_mes,
        nombre_dia_semana,
        es_fin_de_semana
    )
    SELECT %s,%s,%s,%s,%s,%s,%s,%s
    WHERE NOT EXISTS (
        SELECT 1 FROM dw.dim_fecha df WHERE df.fecha = %s
    );
    """

    # batch agrega el parámetro final (fecha) para el NOT EXISTS
    batch = [r + (r[0],) for r in rows]

    with conn.cursor() as cur:
        execute_batch(cur, sql, batch, page_size=200)

# 6 - MAIN
def main():
    args = parse_args()
    start, end = periodo_to_range(args.periodo)
    rows = build_rows(start, end)

    conn = get_conn()
    try:
        conn.autocommit = False

        # Validación mínima de precondición: tabla existe
        with conn.cursor() as cur:
            cur.execute("SELECT to_regclass('dw.dim_fecha');")
            reg = cur.fetchone()[0]
            if reg is None:
                raise RuntimeError("No existe dw.dim_fecha. Detener: falta aplicar DDL del esquema dw.")

        load_dim_fecha(conn, rows)
        conn.commit()

        print(f"[OK] dim_fecha cargada (idempotente) para periodo {args.periodo} | dias_en_periodo={len(rows)}")
    except Exception as e:
        conn.rollback()
        raise
    finally:
        conn.close()

if __name__ == "__main__":
    main()
