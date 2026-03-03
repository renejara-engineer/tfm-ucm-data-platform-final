#!/usr/bin/env bash
set -euo pipefail

# ==========================================================
# deployment/run_demo.sh (RELEASE) - v4.1 (terminal-first)
# - Todo lo importante se VE en terminal y queda en evidencia (secciones siempre visibles).
# - Portable (sin rutas absolutas), idempotente.
# - Crea .env.demo desde .env.demo.example si falta (clone limpio).
# ==========================================================

PROJECT_NAME="${PROJECT_NAME:-tfm_demo}"
ENV_FILE="${ENV_FILE:-.env.demo}"
ENV_EXAMPLE="${ENV_EXAMPLE:-.env.demo.example}"

COMPOSE_CORE="${COMPOSE_CORE:-docker-compose.portable.yml}"
COMPOSE_N8N="${COMPOSE_N8N:-docker-compose.n8n.yml}"

PERIOD="${PERIOD:-2024-09}"

# Flags opcionales
SHOW_STG="${SHOW_STG:-0}"  # 1: imprime \d stg_* (si existen)
SHOW_TOP="${SHOW_TOP:-0}"  # 1: imprime top 5 de facts (puede ser sensible)

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

TS="$(date +%Y-%m-%d_%H%M%S)"
EVD_DIR="deployment/evidence/DEMO/${TS}"
mkdir -p "$EVD_DIR"

log()  { echo "INFO: $*" | tee -a "$EVD_DIR/run.log" >&2; }
warn() { echo "WARN: $*" | tee -a "$EVD_DIR/run.log" >&2; }
die()  { echo "ERROR: $*" | tee -a "$EVD_DIR/run.log" >&2; exit 1; }

section() {
  echo
  echo "============================================================"
  echo "$*"
  echo "============================================================"
}

on_error() { warn "Fallo en línea ${BASH_LINENO[0]} (exit=$?). Evidencia: $EVD_DIR"; }
trap on_error ERR

section "0) CONTEXTO"
log "WORKDIR=$(pwd)"
log "EVIDENCE_DIR=$EVD_DIR"
log "PROJECT_NAME=$PROJECT_NAME"
log "PERIOD=$PERIOD"
log "ENV_FILE=$ENV_FILE"
log "ENV_EXAMPLE=$ENV_EXAMPLE"
log "COMPOSE_CORE=$COMPOSE_CORE"
log "COMPOSE_N8N=$COMPOSE_N8N"
log "SHOW_STG=$SHOW_STG SHOW_TOP=$SHOW_TOP"

# --- bootstrap env file (clone-friendly)
if [[ ! -f "$ENV_FILE" ]]; then
  if [[ -f "$ENV_EXAMPLE" ]]; then
    warn "No existe $ENV_FILE. Creándolo desde $ENV_EXAMPLE (clon limpio)."
    cp "$ENV_EXAMPLE" "$ENV_FILE"
    warn "Revisa $ENV_FILE si deseas cambiar puertos/credenciales DEMO."
  else
    die "NO CONSTA $ENV_FILE ni plantilla $ENV_EXAMPLE. Debes versionar $ENV_EXAMPLE y reintentar."
  fi
fi

[[ -f "$COMPOSE_CORE" ]] || die "No existe $COMPOSE_CORE (root del repo)"
[[ -f "$COMPOSE_N8N"  ]] || die "No existe $COMPOSE_N8N (root del repo)"

command -v docker >/dev/null 2>&1 || die "docker no está instalado/en PATH"
docker version >/dev/null 2>&1 || die "docker daemon no responde"
docker compose version >/dev/null 2>&1 || die "docker compose no disponible"
command -v curl >/dev/null 2>&1 || die "curl no está instalado/en PATH (requerido en host)"

# --- git snapshot (best-effort)
git rev-parse HEAD > "$EVD_DIR/git_commit.txt" 2>/dev/null || true
git status --porcelain > "$EVD_DIR/git_status_porcelain.txt" 2>/dev/null || true

compose() {
  docker compose -p "$PROJECT_NAME" --env-file "$ENV_FILE" -f "$COMPOSE_CORE" -f "$COMPOSE_N8N" "$@"
}

run_psql() {
  # $1: filename (sin ruta)  $2: comando/SQL para psql (string; puede incluir meta-comandos \dn \dt \dv)
  local out="$EVD_DIR/$1"
  local script="$2"

  # Ejecuta psql leyendo desde STDIN (evita problemas de escape/quoting con \dn, \dt, etc.)
  # -X: no lee ~/.psqlrc
  # -v ON_ERROR_STOP=1: falla si hay error
  # Mostramos en terminal y persistimos stdout+stderr
  printf '%s\n' "$script" \
    | compose exec -T chile-pg sh -lc 'psql -X -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB"' \
    2>&1 | tee "$out"
}

run_psql_allow_fail() {
  # Igual que run_psql, pero no detiene el script (para secciones opcionales)
  local out="$EVD_DIR/$1"
  local script="$2"
  printf '%s\n' "$script" \
    | compose exec -T chile-pg sh -lc 'psql -X -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB"' \
    2>&1 | tee "$out" || true
}

section "1) STACK (UP + PS)"
log "Levantando stack DEMO (idempotente)..."
compose up -d --build 2>&1 | tee "$EVD_DIR/compose_up.txt"
compose ps 2>&1 | tee "$EVD_DIR/compose_ps.txt"

section "2) PUERTOS (EVIDENCIA)"
compose port etl 8000     2>&1 | tee "$EVD_DIR/port_etl_8000.txt"     || true
compose port chile-pg 5432 2>&1 | tee "$EVD_DIR/port_pg_5432.txt"      || true
compose port n8n 5678     2>&1 | tee "$EVD_DIR/port_n8n_5678.txt"     || true
compose port pgadmin 80   2>&1 | tee "$EVD_DIR/port_pgadmin_80.txt"   || true

# --- resolve ETL host port (del env file)
ETL_PORT="$(grep -E '^ETL_PORT=' "$ENV_FILE" | tail -n1 | cut -d= -f2- | tr -d '\r')"
ETL_PORT="${ETL_PORT:-9000}"
ETL_URL="http://localhost:${ETL_PORT}"

section "3) HEALTH ETL (HOST + RETRY)"
log "Healthcheck ETL (host): ${ETL_URL}/health"
host_ok=0
for i in $(seq 1 20); do
  code="$(curl -sS -o "$EVD_DIR/etl_health_host.json" -w "%{http_code}" "${ETL_URL}/health" || true)"
  echo "try=$i code=$code" | tee -a "$EVD_DIR/etl_health_host_attempts.txt"
  if [[ "$code" == "200" ]]; then
    host_ok=1
    echo >> "$EVD_DIR/etl_health_host.json"
    break
  fi
  sleep 2
done

if [[ "$host_ok" != "1" ]]; then
  warn "Healthcheck host FALLÓ. Fallback: in-container (python) en 8000/9000."
  compose exec -T etl sh -lc 'python - <<PY
import urllib.request
def hit(url):
    try:
        body = urllib.request.urlopen(url, timeout=3).read().decode("utf-8")
        print("OK", url, body)
    except Exception as e:
        print("FAIL", url, repr(e))
hit("http://localhost:9000/health")
hit("http://localhost:8000/health")
PY' 2>&1 | tee "$EVD_DIR/etl_health_incontainer.txt" || true
  echo "HEALTHCHECK_FAILED" > "$EVD_DIR/etl_health_failed.flag"
else
  log "Healthcheck ETL OK"
fi

section "4) DATA LAKE (HOST) - PRESENCIA CSV"
DATA_LAKE_HOST="$(grep -E '^DATA_LAKE_HOST=' "$ENV_FILE" | tail -n1 | cut -d= -f2- | tr -d '\r')"
[[ -n "$DATA_LAKE_HOST" ]] || die "DATA_LAKE_HOST no definido en $ENV_FILE"
DATA_LAKE_HOST="${DATA_LAKE_HOST%\"}"; DATA_LAKE_HOST="${DATA_LAKE_HOST#\"}"

log "DATA_LAKE_HOST=$DATA_LAKE_HOST"
INBOX_LIC="${DATA_LAKE_HOST}/00_INBOX/LIC/${PERIOD}"
INBOX_OC="${DATA_LAKE_HOST}/00_INBOX/OC/${PERIOD}"
mkdir -p "$INBOX_LIC" "$INBOX_OC"

LIC_FILE="${INBOX_LIC}/LIC_${PERIOD}.csv"
OC_FILE="${INBOX_OC}/OC_${PERIOD}.csv"

ls -la "$DATA_LAKE_HOST" 2>&1 | tee "$EVD_DIR/datalake_host_ls.txt" || true
ls -la "$INBOX_LIC" 2>&1 | tee "$EVD_DIR/inbox_lic_ls.txt" || true
ls -la "$INBOX_OC"  2>&1 | tee "$EVD_DIR/inbox_oc_ls.txt" || true

section "5) DW/SEM - OBJETOS (SE VE EN TERMINAL)"
log "Listando schemas, tablas DW y vistas SEM..."
run_psql "01_schemas.txt" "\dn"
run_psql "02_dw_tables.txt" "\dt dw.*"
run_psql "03_dw_sem_views.txt" "\dv dw_sem.*"
run_psql "04_dw_sem_views_info_schema.txt" "select table_schema, table_name from information_schema.views where table_schema='dw_sem' order by 1,2;"

if [[ "$SHOW_STG" == "1" ]]; then
  section "5B) STG - DESCRIPCIÓN DE TABLAS (OPCIONAL)"
  # Intentamos describir tablas comunes (best-effort)
  run_psql_allow_fail "05_stg_lic_desc.txt" "\d public.stg_lic_$(echo "$PERIOD" | tr '-' '_')"
  run_psql_allow_fail "06_stg_oc_desc.txt"  "\d public.stg_oc_$(echo "$PERIOD" | tr '-' '_')"
fi

section "6) RUN_PERIOD (ETL) - EJECUCIÓN"
if [[ ! -f "$LIC_FILE" || ! -f "$OC_FILE" ]]; then
  warn "Faltan CSV DEMO en INBOX. No se ejecuta /run_period."
  warn "Esperado: $LIC_FILE"
  warn "Esperado: $OC_FILE"
  echo "MISSING_CSV" > "$EVD_DIR/missing_csv.flag"
else
  log "CSV DEMO presentes. Tamaños:"
  ls -lh "$LIC_FILE" "$OC_FILE" 2>&1 | tee "$EVD_DIR/inbox_files_sizes.txt"

  log "POST ${ETL_URL}/run_period (period=${PERIOD})"
  curl -sS -X POST "${ETL_URL}/run_period" \
    -H "Content-Type: application/json" \
    -d "{\"period\":\"${PERIOD}\"}" \
    2>&1 | tee "$EVD_DIR/etl_run_period_response.json"
  echo >> "$EVD_DIR/etl_run_period_response.json"
fi

section "7) DW - RESULTADOS (CONTROL + COUNTS)"
run_psql "07_etl_control_cargas_count.txt" "select count(*) as etl_control_cargas from dw.etl_control_cargas;"
run_psql "08_fact_licitaciones_count.txt" "select count(*) as fact_licitaciones from dw.fact_licitaciones;"
run_psql "09_fact_ordenes_compra_count.txt" "select count(*) as fact_ordenes_compra from dw.fact_ordenes_compra;"
run_psql "10_etl_control_cargas_${PERIOD}.txt" "select entidad,periodo,estado,filas_stg,filas_dw,ts_fin,error_msg from dw.etl_control_cargas where periodo='${PERIOD}' order by entidad;"

if [[ "$SHOW_TOP" == "1" ]]; then
  section "7B) TOP 5 FACTS (OPCIONAL - PUEDE SER SENSIBLE)"
  run_psql "11_top5_fact_lic_${PERIOD}.txt" "select * from dw.fact_licitaciones where periodo='${PERIOD}' limit 5;"
  run_psql "12_top5_fact_oc_${PERIOD}.txt"  "select * from dw.fact_ordenes_compra where periodo='${PERIOD}' limit 5;"
fi

section "8) LOGS (TAIL) - EVIDENCIA"
log "Logs ETL (tail 400)"
compose logs --no-color --tail 400 etl 2>&1 | tee "$EVD_DIR/etl_logs_tail400.txt" || true

log "Logs n8n (tail 200)"
compose logs --no-color --tail 200 n8n 2>&1 | tee "$EVD_DIR/n8n_logs_tail200.txt" || true

section "9) SUMMARY (FIN)"
echo "EVIDENCE_DIR=$EVD_DIR" | tee "$EVD_DIR/summary.txt"
echo "ETL_HEALTH=${ETL_URL}/health" | tee -a "$EVD_DIR/summary.txt"
N8N_PORT="$(grep -E '^N8N_PORT=' "$ENV_FILE" | tail -n1 | cut -d= -f2- | tr -d '\r')"
N8N_PORT="${N8N_PORT:-5678}"
echo "N8N_URL=http://localhost:${N8N_PORT}" | tee -a "$EVD_DIR/summary.txt"

log "DONE"
