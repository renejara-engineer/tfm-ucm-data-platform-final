import argparse
import os
from pathlib import Path

import pandas as pd
import psycopg

DATA_LAKE_ROOT = Path(os.getenv("DATA_LAKE_ROOT", "/data_lake"))
INBOX = DATA_LAKE_ROOT / "00_INBOX"

DB_CFG = {
    "host": os.getenv("DB_HOST", "chile-pg"),
    "port": int(os.getenv("DB_PORT", "5432")),
    "dbname": os.getenv("DB_NAME", "chilecompra"),
    "user": os.getenv("DB_USER", "chile_user"),
    "password": os.getenv("DB_PASS", ""),
}

def read_csv_safely(path: Path) -> pd.DataFrame:
    try:
        return pd.read_csv(path, dtype=str, encoding="utf-8", sep=";", engine="python", on_bad_lines="warn")
    except UnicodeDecodeError:
        return pd.read_csv(path, dtype=str, encoding="latin-1", sep=";", engine="python", on_bad_lines="warn")

def normalize_columns(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    df.columns = (
        df.columns.str.strip().str.lower()
        .str.replace(" ", "_").str.replace("/", "_").str.replace("-", "_")
    )
    return df

def create_stg(conn: psycopg.Connection, table: str, df: pd.DataFrame) -> None:
    cols = df.columns
    col_defs = ",\n  ".join(f'"{c}" text' for c in cols)

    with conn.cursor() as cur:
        cur.execute("CREATE SCHEMA IF NOT EXISTS stg;")
        cur.execute(f"DROP TABLE IF EXISTS stg.{table};")
        cur.execute(f"""CREATE TABLE stg.{table} (
  {col_defs}
);""")

def load_stg(conn: psycopg.Connection, table: str, df: pd.DataFrame) -> None:
    df_clean = df.where(pd.notnull(df), None)
    cols = list(df_clean.columns)
    col_list = ", ".join(f'"{c}"' for c in cols)
    placeholders = ", ".join(["%s"] * len(cols))
    ins = f'INSERT INTO stg.{table} ({col_list}) VALUES ({placeholders});'
    rows = df_clean.to_numpy().tolist()
    with conn.cursor() as cur:
        cur.executemany(ins, rows)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--period", required=True)
    args = ap.parse_args()

    period = args.period
    tag = period.replace("-", "_")

    lic_csv = INBOX / "LIC" / period / f"LIC_{period}.csv"
    oc_csv  = INBOX / "OC"  / period / f"OC_{period}.csv"

    if not lic_csv.exists() or lic_csv.stat().st_size == 0:
        raise SystemExit(f"Missing LIC CSV: {lic_csv}")
    if not oc_csv.exists() or oc_csv.stat().st_size == 0:
        raise SystemExit(f"Missing OC CSV: {oc_csv}")

    df_lic = normalize_columns(read_csv_safely(lic_csv))
    df_oc  = normalize_columns(read_csv_safely(oc_csv))

    stg_lic = f"stg_lic_{tag}"
    stg_oc  = f"stg_oc_{tag}"

    with psycopg.connect(**DB_CFG, autocommit=True) as conn:
        create_stg(conn, stg_lic, df_lic)
        load_stg(conn, stg_lic, df_lic)

        create_stg(conn, stg_oc, df_oc)
        load_stg(conn, stg_oc, df_oc)

    print(f"[OK] STG created: {stg_lic}={len(df_lic)} rows, {stg_oc}={len(df_oc)} rows")

if __name__ == "__main__":
    main()
