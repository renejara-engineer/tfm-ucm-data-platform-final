from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import os
import httpx
import psycopg
from psycopg.rows import dict_row
import subprocess

app = FastAPI()

DB_CFG = {
    "host": os.getenv("DB_HOST", "chile-pg"),
    "port": int(os.getenv("DB_PORT", "5432")),
    "dbname": os.getenv("DB_NAME", "chilecompra"),
    "user": os.getenv("DB_USER", "chile_user"),
    "password": os.getenv("DB_PASS", ""),
}

API_KEY = os.getenv("CHILECOMPRA_API_KEY")  # puede ser None

@app.get("/health")
async def health():
    # DB ping
    try:
        with psycopg.connect(**DB_CFG) as conn:
            with conn.cursor(row_factory=dict_row) as cur:
                cur.execute("select 1 as ok")
                _ = cur.fetchone()
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"db_error: {e!s}")
    # No exigimos API_KEY para /health
    return {"status": "ok", "db": "ok", "api_key_present": bool(API_KEY)}

class RunParams(BaseModel):
    days: int = 7

@app.post("/run")
async def run(params: RunParams):
    if not API_KEY:
        raise HTTPException(status_code=400, detail="Falta CHILECOMPRA_API_KEY en el entorno")

    # Ejemplo minimal: hace un GET “ping” a la API (ajústalo cuando tengas key real)
    url = "https://api.mercadopublico.cl/servicios/v1/publico/licitaciones.json"
    q = {"ticket": API_KEY, "fecha": "hoy"}  # placeholder

    try:
        async with httpx.AsyncClient(timeout=30) as client:
            r = await client.get(url, params=q)
            r.raise_for_status()
            data = r.json()
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"api_error: {e!s}")

    # Guarda “hello” en DB para probar escritura
    try:
        with psycopg.connect(**DB_CFG, autocommit=True) as conn:
            with conn.cursor() as cur:
                cur.execute("CREATE TABLE IF NOT EXISTS etl_runs(id serial primary key, note text, ts timestamptz default now())")
                cur.execute("INSERT INTO etl_runs(note) VALUES (%s)", ("ok sin datos reales",))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"db_write_error: {e!s}")

    return {"ok": True, "fetched": isinstance(data, dict)}

class RunPeriodParams(BaseModel):
    period: str  # "YYYY-MM"

@app.post("/run_period")
async def run_period(p: RunPeriodParams):
    try:
        cp = subprocess.run(
            ["python", "/app/run_period.py", "--period", p.period],
            capture_output=True, text=True, check=False
        )
        if cp.returncode != 0:
            raise HTTPException(status_code=500, detail={
                "error": "run_period_failed",
                "returncode": cp.returncode,
                "stderr": cp.stderr[-2000:],
                "stdout": cp.stdout[-2000:],
            })
        return {"ok": True, "period": p.period, "stdout_tail": cp.stdout[-2000:]}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"exception: {e!s}")

