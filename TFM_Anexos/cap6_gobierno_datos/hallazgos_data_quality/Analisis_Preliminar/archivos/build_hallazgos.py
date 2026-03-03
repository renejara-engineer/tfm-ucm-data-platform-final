#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""build_hallazgos.py (FULL mode)
Genera evidencias de gobierno de datos (EDA operacional) para biblioteca CSV ChileCompra.

Diseño: DISK-FIRST + STREAMING + TOLERANTE A ERRORES
- No carga datasets completos en RAM.
- Registra incidentes y continúa.
- Produce artefactos en 04_Hallazgos/ y un resumen findings.json.

Ejecución (FULL):
  python build_hallazgos.py --mode full \
    --base-dir /home/engineer/Documents/Proyectos/TFM_CSV_Biblioteca_Readme

Opcional:
  --max-files 2           (para debug)
  --chunksize 50000
  --run-inter-month-hash  (habilita persistencias inter-mes via DuckDB)
"""

from __future__ import annotations

import argparse
import csv
import datetime as _dt
import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List, Optional, Tuple

import pandas as pd

try:
    import duckdb  # type: ignore
except Exception:
    duckdb = None


# -----------------------------
# 0) Utilidades base (logging / JSON safe)
# -----------------------------

def now_iso() -> str:
    return _dt.datetime.now().isoformat(timespec="seconds")

def json_safe(o):
    """Convierte tipos no serializables (numpy/pandas) a nativos JSON."""
    try:
        import numpy as np  # local import
        if isinstance(o, (np.integer,)):
            return int(o)
        if isinstance(o, (np.floating,)):
            return float(o)
        if isinstance(o, (np.bool_,)):
            return bool(o)
    except Exception:
        pass
    if hasattr(o, "isoformat"):
        try:
            return o.isoformat()
        except Exception:
            pass
    if isinstance(o, Path):
        return str(o)
    return str(o)

def write_json(path: Path, obj) -> None:
    path.write_text(json.dumps(obj, ensure_ascii=False, indent=2, default=json_safe), encoding="utf-8")

def append_jsonl(path: Path, obj) -> None:
    with path.open("a", encoding="utf-8") as f:
        f.write(json.dumps(obj, ensure_ascii=False, default=json_safe) + "\n")

@dataclass
class Incident:
    dataset: str
    file: str
    severity: str
    reasons: List[str]
    detail: Optional[dict] = None

def log_line(log_path: Path, msg: str) -> None:
    with log_path.open("a", encoding="utf-8") as f:
        f.write(f"[{now_iso()}] {msg}\n")

def record_incident(inc_path: Path, inc: Incident) -> None:
    append_jsonl(inc_path, {
        "ts": now_iso(),
        "dataset": inc.dataset,
        "file": inc.file,
        "severity": inc.severity,
        "reasons": inc.reasons,
        "detail": inc.detail or {}
    })


# -----------------------------
# 1) Lectura robusta CSV (detect_delimiter / safe_read_csv / iter_chunks_safe)
# -----------------------------

SNIFF_BYTES = 65536

def detect_delimiter(path: Path, default: str = ";") -> str:
    """Detecta delimitador con csv.Sniffer. Fallback seguro ';'."""
    try:
        raw = path.read_bytes()[:SNIFF_BYTES]
        semi = raw.count(b";")
        comma = raw.count(b",")
        if semi > comma * 2:
            return ";"
        if comma > semi * 2:
            return ","
        sample = raw.decode("utf-8", errors="ignore")
        dialect = csv.Sniffer().sniff(sample, delimiters=[",", ";", "\t", "|"])
        return dialect.delimiter
    except Exception:
        return default

def try_read_csv_head(path: Path, sep: str, encoding: str) -> Optional[pd.DataFrame]:
    try:
        return pd.read_csv(
            path,
            sep=sep,
            dtype=str,
            engine="python",
            on_bad_lines="skip",
            encoding=encoding,
            encoding_errors="ignore",
            nrows=5,
            low_memory=False,
        )
    except Exception:
        return None

def safe_read_csv_kwargs(path: Path, dataset: str, inc_path: Path, log_path: Path) -> Dict:
    """Devuelve kwargs robustos para pandas.read_csv (sep + encoding)."""
    sep = detect_delimiter(path)
    enc = "utf-8"
    head = try_read_csv_head(path, sep=sep, encoding=enc)
    if head is None:
        enc = "latin1"
        head = try_read_csv_head(path, sep=sep, encoding=enc)

    if head is None:
        record_incident(inc_path, Incident(dataset, path.name, "alta",
                                           ["read_head_failed"],
                                           {"sep": sep, "tried_encodings": ["utf-8", "latin1"]}))
        log_line(log_path, f"[{dataset}] head read FAILED: {path.name} (sep={sep})")
        enc = "latin1"

    return dict(
        sep=sep,
        dtype=str,
        engine="python",
        on_bad_lines="skip",
        encoding=enc,
        encoding_errors="ignore",
        low_memory=False,
    )

def iter_chunks_safe(path: Path, dataset: str, inc_path: Path, log_path: Path, chunksize: int) -> Iterable[pd.DataFrame]:
    """Itera chunks sin abortar el pipeline; registra incidente y continúa."""
    kwargs = safe_read_csv_kwargs(path, dataset, inc_path, log_path)
    try:
        for chunk in pd.read_csv(path, chunksize=chunksize, **kwargs):
            yield chunk
    except Exception as e:
        record_incident(inc_path, Incident(dataset, path.name, "alta",
                                           ["read_chunks_failed"],
                                           {"error": repr(e), "kwargs": kwargs}))
        log_line(log_path, f"[{dataset}] chunks read FAILED: {path.name} err={repr(e)}")
        return


# -----------------------------
# 2) Normalización de claves y helpers de profiling
# -----------------------------

_re_digits = re.compile(r"\d+")

def normalize_code(x: Optional[str]) -> Optional[str]:
    """Normaliza códigos: '7251.0'->'7251', strips, solo dígitos."""
    if x is None:
        return None
    s = str(x).strip()
    if s == "" or s.lower() in {"nan", "none", "null", "na"}:
        return None
    if s.endswith(".0"):
        s = s[:-2]
    digs = _re_digits.findall(s)
    if not digs:
        return None
    return "".join(digs)

def pick_first_col(cols: List[str], patterns: List[str]) -> Optional[str]:
    cols_l = {c.lower(): c for c in cols}
    for pat in patterns:
        for cl, orig in cols_l.items():
            if pat in cl:
                return orig
    return None

def safe_topk_dict(d: Dict[str, float], k: int = 30) -> Dict[str, float]:
    items = sorted(d.items(), key=lambda kv: kv[1], reverse=True)[:k]
    return {kk: float(vv) for kk, vv in items}

def infer_simple_type(samples: List[str]) -> str:
    s = [x for x in samples if x is not None and str(x).strip() != ""]
    if not s:
        return "TEXT"
    if all(re.fullmatch(r"\d+", str(x).strip()) for x in s[:50]):
        return "BIGINT"
    if all(re.fullmatch(r"\d+([.,]\d+)?", str(x).strip()) for x in s[:50]):
        return "NUMERIC"
    date_like = 0
    for x in s[:50]:
        try:
            pd.to_datetime(str(x), errors="raise")
            date_like += 1
        except Exception:
            pass
    if date_like >= max(3, len(s[:50]) // 2):
        return "TIMESTAMP"
    return "TEXT"


# -----------------------------
# 3) DuckDB helpers (dedup intra + inter mes)
# -----------------------------

def ensure_duckdb(db_path: Path, log_path: Path):
    if duckdb is None:
        log_line(log_path, "DuckDB no disponible: omitiendo hashing inter-mes / dedup por DB.")
        return None
    con = duckdb.connect(str(db_path))
    con.execute("""
        CREATE TABLE IF NOT EXISTS rowhashes (
            dataset VARCHAR,
            file VARCHAR,
            h UBIGINT
        );
    """)
    return con

def clear_duckdb(con) -> None:
    con.execute("DELETE FROM rowhashes;")

def insert_hashes(con, dataset: str, file: str, hashes: List[int]) -> None:
    con.executemany("INSERT INTO rowhashes(dataset, file, h) VALUES (?, ?, ?);",
                    [(dataset, file, int(h)) for h in hashes])

def file_dup_stats(con, dataset: str, file: str) -> Tuple[int, int, int]:
    total = con.execute("SELECT COUNT(*) FROM rowhashes WHERE dataset=? AND file=?;", [dataset, file]).fetchone()[0]
    distinct = con.execute("SELECT COUNT(DISTINCT h) FROM rowhashes WHERE dataset=? AND file=?;", [dataset, file]).fetchone()[0]
    return int(total), int(distinct), int(total - distinct)


# -----------------------------
# 4) Pipeline helpers
# -----------------------------

def list_csv_files(folder: Path, glob_pat: str, max_files: Optional[int]) -> List[Path]:
    files = sorted(folder.glob(glob_pat))
    if max_files is not None:
        files = files[:max_files]
    return files

def inventory_csv(files: List[Path], dataset: str, inc_path: Path, log_path: Path) -> pd.DataFrame:
    rows = []
    for p in files:
        try:
            st = p.stat()
            sep = detect_delimiter(p)
            rows.append({
                "dataset": dataset,
                "file": p.name,
                "path": str(p),
                "bytes": int(st.st_size),
                "mtime": _dt.datetime.fromtimestamp(st.st_mtime).isoformat(timespec="seconds"),
                "sep_guess": sep,
            })
        except Exception as e:
            record_incident(inc_path, Incident(dataset, p.name, "media", ["stat_failed"], {"error": repr(e)}))
            log_line(log_path, f"[{dataset}] stat failed: {p.name} err={repr(e)}")
    return pd.DataFrame(rows)

def profile_dataset(files: List[Path], dataset: str, inc_path: Path, log_path: Path,
                    hall_dir: Path, chunksize: int, con=None) -> Tuple[pd.DataFrame, Path, Path]:
    profiles_jsonl = hall_dir / f"{dataset}_profiles.jsonl"
    if profiles_jsonl.exists():
        profiles_jsonl.unlink()
    dict_md = hall_dir / f"{dataset}_dict.md"
    summary_rows = []

    col_presence: Dict[str, int] = {}
    col_null_sum: Dict[str, int] = {}
    col_count_sum: Dict[str, int] = {}
    col_samples: Dict[str, List[str]] = {}

    for p in files:
        total_rows = 0
        columns: Optional[List[str]] = None
        null_counts: Dict[str, int] = {}
        value_samples: Dict[str, List[str]] = {}
        ok_read = False
        hashes_total = 0

        for chunk in iter_chunks_safe(p, dataset, inc_path, log_path, chunksize):
            if chunk is None or chunk.empty:
                continue
            ok_read = True
            if columns is None:
                columns = list(chunk.columns)
                for c in columns:
                    col_presence[c] = col_presence.get(c, 0) + 1

            n = len(chunk)
            total_rows += n

            nc = chunk.isna().sum().to_dict()
            for k, v in nc.items():
                null_counts[k] = null_counts.get(k, 0) + int(v)

            for c in chunk.columns[:200]:
                if c not in value_samples:
                    value_samples[c] = []
                if len(value_samples[c]) < 5:
                    vals = chunk[c].dropna().astype(str).head(5 - len(value_samples[c])).tolist()
                    value_samples[c].extend(vals)

            if con is not None:
                try:
                    h = pd.util.hash_pandas_object(chunk, index=False).astype("uint64").tolist()
                    hashes_total += len(h)
                    insert_hashes(con, dataset, p.name, h)
                except Exception as e:
                    record_incident(inc_path, Incident(dataset, p.name, "media", ["hash_failed"], {"error": repr(e)}))
                    log_line(log_path, f"[{dataset}] hash failed: {p.name} err={repr(e)}")

        if not ok_read:
            record_incident(inc_path, Incident(dataset, p.name, "alta", ["no_rows_read"], {}))
            log_line(log_path, f"[{dataset}] no rows read: {p.name}")

        cols_n = len(columns) if columns else 0
        null_pct = {}
        if columns and total_rows > 0:
            for c in columns:
                null_pct[c] = round(100.0 * null_counts.get(c, 0) / total_rows, 4)

        dup_count = None
        distinct_hashes = None
        if con is not None and hashes_total > 0:
            try:
                tot, dist, dups = file_dup_stats(con, dataset, p.name)
                dup_count = dups
                distinct_hashes = dist
            except Exception as e:
                record_incident(inc_path, Incident(dataset, p.name, "media", ["dup_stats_failed"], {"error": repr(e)}))

        if columns:
            for c in columns:
                col_null_sum[c] = col_null_sum.get(c, 0) + null_counts.get(c, 0)
                col_count_sum[c] = col_count_sum.get(c, 0) + total_rows
                if c not in col_samples:
                    col_samples[c] = []
                for v in value_samples.get(c, [])[:5]:
                    if len(col_samples[c]) < 8 and v not in col_samples[c]:
                        col_samples[c].append(v)

        prof = {
            "dataset": dataset,
            "file": p.name,
            "rows": total_rows,
            "columns_n": cols_n,
            "columns": columns or [],
            "null_pct_top": safe_topk_dict(null_pct, 30),
            "sep_used": safe_read_csv_kwargs(p, dataset, inc_path, log_path).get("sep"),
            "encoding_used": safe_read_csv_kwargs(p, dataset, inc_path, log_path).get("encoding"),
            "dup_rows_intra_month": dup_count,
            "distinct_rowhashes": distinct_hashes,
        }
        append_jsonl(profiles_jsonl, prof)

        summary_rows.append({
            "dataset": dataset,
            "file": p.name,
            "rows": total_rows,
            "columns_n": cols_n,
            "dup_rows_intra_month": dup_count if dup_count is not None else "",
        })

        log_line(log_path, f"[{dataset}] profiled {p.name}: rows={total_rows} cols={cols_n} dup_intra={dup_count}")

    summary_df = pd.DataFrame(summary_rows)

    dict_lines = [f"# Diccionario operativo – {dataset}", ""]
    dict_lines.append("> Generado automáticamente. Orientado a STAGING (PostgreSQL): tipos sugeridos y llaves candidatas.")
    dict_lines.append("")
    dict_lines.append("| columna | presencia_archivos | null_pct_global | tipo_sugerido | ejemplos |")
    dict_lines.append("|---|---:|---:|---|---|")
    for col in sorted(col_presence.keys()):
        pres = col_presence.get(col, 0)
        cnt = col_count_sum.get(col, 0)
        nulls = col_null_sum.get(col, 0)
        null_pct_global = (100.0 * nulls / cnt) if cnt else 0.0
        samples = col_samples.get(col, [])[:4]
        tipo = infer_simple_type(samples)
        ex = "; ".join(samples).replace("\n", " ")[:120]
        dict_lines.append(f"| {col} | {pres} | {null_pct_global:.2f}% | {tipo} | {ex} |")
    dict_md.write_text("\n".join(dict_lines), encoding="utf-8")

    return summary_df, profiles_jsonl, dict_md

def gate_basic(file_rows: int, cols_n: int) -> Tuple[bool, List[str]]:
    reasons = []
    if file_rows <= 0:
        reasons.append("rows_zero")
    if cols_n <= 0:
        reasons.append("cols_zero")
    return (len(reasons) == 0), reasons

def build_quality_gates(summary_df: pd.DataFrame, dataset: str) -> pd.DataFrame:
    rows = []
    for _, r in summary_df.iterrows():
        ok, reasons = gate_basic(int(r.get("rows", 0)), int(r.get("columns_n", 0)))
        rows.append({
            "dataset": dataset,
            "file": r.get("file"),
            "ok": ok,
            "reasons": "|".join(reasons) if reasons else ""
        })
    return pd.DataFrame(rows)

def read_org_master(org_file: Path, inc_path: Path, log_path: Path, chunksize: int) -> Tuple[set, Dict[str, str], Dict]:
    codes = set()
    code_to_name: Dict[str, str] = {}
    cols_info = {"code_col": None, "name_col": None, "columns": []}
    first_cols: Optional[List[str]] = None

    for chunk in iter_chunks_safe(org_file, "ORG", inc_path, log_path, chunksize):
        if chunk is None or chunk.empty:
            continue
        if first_cols is None:
            first_cols = list(chunk.columns)
            cols_info["columns"] = first_cols
            code_col = pick_first_col(first_cols, ["código", "codigo", "cod"])
            name_col = pick_first_col(first_cols, ["nombre", "institución", "institucion"])
            cols_info["code_col"] = code_col
            cols_info["name_col"] = name_col

        code_col = cols_info["code_col"]
        name_col = cols_info["name_col"]
        if not code_col or code_col not in chunk.columns:
            continue

        cvals = chunk[code_col].astype(str).map(normalize_code)
        nvals = chunk[name_col].astype(str) if (name_col and name_col in chunk.columns) else None
        for i, c in enumerate(cvals.tolist()):
            if not c:
                continue
            codes.add(c)
            if nvals is not None:
                nm = str(nvals.iloc[i]).strip()
                if nm and c not in code_to_name:
                    code_to_name[c] = nm

    return codes, code_to_name, cols_info

def unique_codes_from_files(files: List[Path], dataset: str, code_col_patterns: List[str],
                            inc_path: Path, log_path: Path, chunksize: int,
                            max_examples: int = 200,
                            name_col_patterns: Optional[List[str]] = None) -> Tuple[set, Dict[str, Dict], Dict]:
    codes = set()
    examples: Dict[str, Dict] = {}
    info = {"code_col": None, "name_col": None}

    for p in files:
        first = True
        for chunk in iter_chunks_safe(p, dataset, inc_path, log_path, chunksize):
            if chunk is None or chunk.empty:
                continue
            if first:
                cols = list(chunk.columns)
                info["code_col"] = info["code_col"] or pick_first_col(cols, [x.lower() for x in code_col_patterns])
                if name_col_patterns:
                    info["name_col"] = info["name_col"] or pick_first_col(cols, [x.lower() for x in name_col_patterns])
                first = False

            code_col = info["code_col"]
            if not code_col or code_col not in chunk.columns:
                continue

            cvals = chunk[code_col].astype(str).map(normalize_code)
            nvals = None
            name_col = info.get("name_col")
            if name_col and name_col in chunk.columns:
                nvals = chunk[name_col].astype(str)

            for i, c in enumerate(cvals.tolist()):
                if not c:
                    continue
                codes.add(c)
                if len(examples) < max_examples and c not in examples:
                    ex = {"code": c, "dataset": dataset, "file": p.name}
                    if nvals is not None:
                        ex["name"] = str(nvals.iloc[i]).strip()
                    examples[c] = ex
        log_line(log_path, f"[{dataset}] extracted codes from {p.name}: running_unique={len(codes)}")

    return codes, examples, info

def build_relationships(lic_files: List[Path], oc_files: List[Path], org_file: Path,
                        inc_path: Path, log_path: Path, chunksize: int) -> Tuple[dict, pd.DataFrame]:
    org_codes, org_map, org_cols = read_org_master(org_file, inc_path, log_path, chunksize)

    lic_codes, lic_ex, lic_info = unique_codes_from_files(
        lic_files, "LIC", ["codigoorganismo"], inc_path, log_path, chunksize,
        max_examples=250, name_col_patterns=["nombreorganismo", "organismo"]
    )
    oc_codes, oc_ex, oc_info = unique_codes_from_files(
        oc_files, "OC", ["codigoorganismopublico", "codigoorganismo"], inc_path, log_path, chunksize,
        max_examples=250, name_col_patterns=["organismopublico", "organismo"]
    )

    inter_lic_org = lic_codes.intersection(org_codes)
    inter_oc_org = oc_codes.intersection(org_codes)
    inter_lic_oc = lic_codes.intersection(oc_codes)

    metrics = {
        "org": {"n_unique": len(org_codes), "columns_detected": org_cols},
        "lic": {"n_unique": len(lic_codes), "cols_detected": lic_info},
        "oc": {"n_unique": len(oc_codes), "cols_detected": oc_info},
        "intersections": {
            "lic_org": {"n": len(inter_lic_org), "ratio_lic": (len(inter_lic_org) / len(lic_codes) if lic_codes else 0.0)},
            "oc_org": {"n": len(inter_oc_org), "ratio_oc": (len(inter_oc_org) / len(oc_codes) if oc_codes else 0.0)},
            "lic_oc": {"n": len(inter_lic_oc), "ratio_lic": (len(inter_lic_oc) / len(lic_codes) if lic_codes else 0.0)},
        }
    }

    rows = []
    for c in sorted(list(inter_lic_org))[:120]:
        rows.append({
            "code": c,
            "org_name": org_map.get(c, ""),
            "lic_name": lic_ex.get(c, {}).get("name", ""),
            "oc_name": oc_ex.get(c, {}).get("name", ""),
        })
    ex_df = pd.DataFrame(rows)

    if len(inter_lic_org) == 0 and len(lic_codes) > 0 and len(org_codes) > 0:
        record_incident(inc_path, Incident("REL", org_file.name, "media",
                                           ["zero_intersection_lic_org"],
                                           {"hint": "posible diferencia de taxonomía/códigos; revisar normalización o columnas"}))
        log_line(log_path, "[REL] zero intersection LIC↔ORG (posible taxonomía distinta)")

    return metrics, ex_df

def build_postgres_notes(hall_dir: Path) -> None:
    notes = """# PostgreSQL – notas de diseño (Staging + DW)

Estas recomendaciones se basan en hallazgos típicos de datos CSV heterogéneos:
- variación de esquema entre meses (schema drift),
- errores de parsing/encoding,
- claves naturales inconsistentes,
- necesidad de trazabilidad (auditoría).

## Esquemas sugeridos
- `stg`: ingesta raw tipada como texto + columnas auditoría (archivo_origen, mes, hash_fila, fecha_ingesta)
- `clean`: normalizaciones (tipos, fechas, montos, normalización de códigos)
- `dw`: modelo dimensional (facts/dims)
- `meta`: metadatos, calidad, incidentes

## Estrategia de carga
1) Cargar a `stg` con `COPY` / `\\copy` y columnas `TEXT`.
2) Aplicar reglas de limpieza hacia `clean`.
3) Poblar `dw` desde `clean` con claves surrogate.

## Duplicados
- Intra-mes: deduplicar en `stg` por `hash_fila` + `archivo_origen`.
- Inter-mes: NO borrar sin regla de negocio; reportar persistencias.

## Índices mínimos
- `stg`: (archivo_origen), (mes), (hash_fila)
- `dw`: claves surrogate + fechas (si se particiona por periodo)
"""
    (hall_dir / "postgres_design_notes.md").write_text(notes, encoding="utf-8")

    sql = """-- postgres_recommendations.sql (mínimo viable)
CREATE SCHEMA IF NOT EXISTS stg;
CREATE SCHEMA IF NOT EXISTS clean;
CREATE SCHEMA IF NOT EXISTS dw;
CREATE SCHEMA IF NOT EXISTS meta;

-- Recomendación: cargar todo como TEXT en stg y tipar/normalizar en clean.
"""
    (hall_dir / "postgres_recommendations.sql").write_text(sql, encoding="utf-8")

def build_indicadores_stub(hall_dir: Path) -> None:
    write_json(hall_dir / "indicadores.json", {
        "nota": "Indicadores de alto nivel se habilitan tras carga a DW (fuera del alcance de este script).",
        "ejemplos": ["volumen_compras_por_mes", "monto_por_organismo", "top_proveedores"]
    })

def build_findings(rel_metrics: dict, qg: pd.DataFrame, run_inter_month_hash: bool) -> dict:
    return {
        "ts": now_iso(),
        "duplicados": {
            "nota": "Duplicados técnicos intra-mes reportados en *_file_summary.csv.",
            "inter_month_enabled": bool(run_inter_month_hash),
        },
        "relaciones": rel_metrics.get("intersections", {}),
        "quality_gates": {
            "failed_files": int((~qg["ok"]).sum()) if "ok" in qg.columns else None,
        },
        "recomendaciones": [
            "Usar STAGING en PostgreSQL con tipado TEXT, y tipar/normalizar en CLEAN.",
            "No eliminar repetición inter-mes sin regla de negocio; reportar persistencias.",
            "Normalizar códigos antes de evaluar relaciones.",
        ],
    }

def write_readme_placeholder(base_dir: Path, log_path: Path) -> None:
    readme_path = base_dir / "00_Dataset_ChileCompra_Summary_Master.md"
    content = f"""# Dataset ChileCompra – Summary Master (facts-first)

> Generado por `build_hallazgos.py`. Este README es un placeholder técnico.
> La redacción final TFM debe construirse a partir de `04_Hallazgos/`.

## Evidencias principales
- `04_Hallazgos/findings.json`
- `04_Hallazgos/*_file_summary.csv`
- `04_Hallazgos/*_dict.md`
- `04_Hallazgos/relationships_metrics.json` + `relationships_examples.csv`
- `04_Hallazgos/quality_gates_summary.csv` + `incidents.jsonl`
- `04_Hallazgos/postgres_design_notes.md` + `postgres_recommendations.sql`

## Reproducibilidad
```bash
python build_hallazgos.py --mode full --base-dir {base_dir}
```
"""
    readme_path.write_text(content, encoding="utf-8")
    log_line(log_path, f"README placeholder escrito en {readme_path}")

def export_inter_month_repeated(con, dataset: str, out_csv: Path, min_files: int = 2, limit: int = 200000) -> None:
    q = f"""
    WITH agg AS (
        SELECT h, COUNT(DISTINCT file) AS n_files
        FROM rowhashes
        WHERE dataset = ?
        GROUP BY h
        HAVING COUNT(DISTINCT file) >= ?
    )
    SELECT h, n_files
    FROM agg
    ORDER BY n_files DESC
    LIMIT {int(limit)};
    """
    df = con.execute(q, [dataset, min_files]).fetchdf()
    df.to_csv(out_csv, index=False)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--mode", choices=["full"], default="full")
    ap.add_argument("--base-dir", required=True)
    ap.add_argument("--max-files", type=int, default=None)
    ap.add_argument("--chunksize", type=int, default=50_000)
    ap.add_argument("--run-inter-month-hash", action="store_true")
    args = ap.parse_args()

    base_dir = Path(args.base_dir).expanduser().resolve()
    lic_dir = base_dir / "01_LIC"
    oc_dir = base_dir / "02_OC"
    org_dir = base_dir / "03_Organismos_Compradores"
    hall_dir = base_dir / "04_Hallazgos"
    hall_dir.mkdir(exist_ok=True)

    log_path = hall_dir / "readme_build_log.txt"
    inc_path = hall_dir / "incidents.jsonl"
    log_path.write_text("", encoding="utf-8")
    if inc_path.exists():
        inc_path.unlink()

    run_cfg = {
        "ts": now_iso(),
        "mode": args.mode,
        "base_dir": str(base_dir),
        "chunksize": args.chunksize,
        "max_files": args.max_files,
        "run_inter_month_hash": bool(args.run_inter_month_hash),
        "python": sys.version.split()[0],
        "pandas": pd.__version__,
        "duckdb_available": duckdb is not None,
    }
    write_json(hall_dir / "run_config.json", run_cfg)
    log_line(log_path, "Inicio build_hallazgos FULL")

    lic_files = list_csv_files(lic_dir, "*.csv", args.max_files)
    oc_files = list_csv_files(oc_dir, "*.csv", args.max_files)
    org_files = list_csv_files(org_dir, "*.csv", 1)
    if not org_files:
        record_incident(inc_path, Incident("ORG", "N/A", "alta", ["org_master_missing"], {"expected": str(org_dir)}))
        raise SystemExit(f"No se encontró maestro ORG en {org_dir}")
    org_file = org_files[0]

    inventory_csv(lic_files, "LIC", inc_path, log_path).to_csv(hall_dir / "raw_inventory_lic.csv", index=False)
    inventory_csv(oc_files, "OC", inc_path, log_path).to_csv(hall_dir / "raw_inventory_oc.csv", index=False)

    db_path = hall_dir / "dups.duckdb"
    con = None
    if duckdb is not None:
        con = ensure_duckdb(db_path, log_path)
        if con is not None:
            clear_duckdb(con)

    lic_sum, _, _ = profile_dataset(lic_files, "LIC", inc_path, log_path, hall_dir, args.chunksize, con=con)
    oc_sum,  _, _ = profile_dataset(oc_files,  "OC",  inc_path, log_path, hall_dir, args.chunksize, con=con)
    org_sum, _, _ = profile_dataset([org_file], "ORG", inc_path, log_path, hall_dir, args.chunksize, con=None)

    lic_sum.to_csv(hall_dir / "LIC_file_summary.csv", index=False)
    oc_sum.to_csv(hall_dir / "OC_file_summary.csv", index=False)
    org_sum.to_csv(hall_dir / "ORG_summary.csv", index=False)

    qg = pd.concat([
        build_quality_gates(lic_sum, "LIC"),
        build_quality_gates(oc_sum, "OC"),
        build_quality_gates(org_sum, "ORG"),
    ], ignore_index=True)
    qg.to_csv(hall_dir / "quality_gates_summary.csv", index=False)

    rel_metrics, rel_examples = build_relationships(lic_files, oc_files, org_file, inc_path, log_path, args.chunksize)
    write_json(hall_dir / "relationships_metrics.json", rel_metrics)
    rel_examples.to_csv(hall_dir / "relationships_examples.csv", index=False)

    if args.run_inter_month_hash and con is not None:
        export_inter_month_repeated(con, "LIC", hall_dir / "inter_month_repeated_hashes_LIC.csv")
        export_inter_month_repeated(con, "OC",  hall_dir / "inter_month_repeated_hashes_OC.csv")
        log_line(log_path, "Inter-month repeated hashes exportado")

    if con is not None:
        try:
            con.close()
        except Exception:
            pass

    build_postgres_notes(hall_dir)
    build_indicadores_stub(hall_dir)

    write_json(hall_dir / "findings.json", build_findings(rel_metrics, qg, args.run_inter_month_hash))
    write_readme_placeholder(base_dir, log_path)

    log_line(log_path, "FIN build_hallazgos FULL")
    print("OK: Hallazgos generados en 04_Hallazgos/.")

if __name__ == "__main__":
    main()
