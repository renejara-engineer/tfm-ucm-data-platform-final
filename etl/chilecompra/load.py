import os
import json
from typing import List, Dict

import psycopg2
from psycopg2.extras import execute_values

def _conn():
    return psycopg2.connect(
        host=os.getenv("CHILE_PG_HOST"),
        port=int(os.getenv("CHILE_PG_PORT", "5432")),
        dbname=os.getenv("CHILE_PG_DB"),
        user=os.getenv("CHILE_PG_USER"),
        password=os.getenv("CHILE_PG_PASSWORD"),
    )

def db_ready():
    try:
        with _conn() as cn:
            with cn.cursor() as cur:
                cur.execute("SELECT 1;")
        return True, "ok"
    except Exception as e:
        return False, f"error: {e}"

def _ensure_table():
    with _conn() as cn:
        with cn.cursor() as cur:
            cur.execute("""
                CREATE TABLE IF NOT EXISTS public.licitaciones (
                  id TEXT PRIMARY KEY,
                  titulo TEXT,
                  estado TEXT,
                  fecha_publicacion TIMESTAMP,
                  monto_estimado NUMERIC,
                  raw JSONB
                );
            """)
        cn.commit()

def load(rows: List[Dict]) -> int:
    _ensure_table()
    if not rows:
        return 0

    values = [
        (
            r["id"], r.get("titulo"), r.get("estado"),
            r.get("fecha_publicacion"), r.get("monto_estimado"),
            json.dumps(r.get("raw", {}))
        )
        for r in rows
    ]

    upsert = """
        INSERT INTO public.licitaciones
        (id, titulo, estado, fecha_publicacion, monto_estimado, raw)
        VALUES %s
        ON CONFLICT (id) DO UPDATE SET
          titulo = EXCLUDED.titulo,
          estado = EXCLUDED.estado,
          fecha_publicacion = EXCLUDED.fecha_publicacion,
          monto_estimado = EXCLUDED.monto_estimado,
          raw = EXCLUDED.raw;
    """
    with _conn() as cn:
        with cn.cursor() as cur:
            execute_values(cur, upsert, values)
        cn.commit()
    return len(values)

