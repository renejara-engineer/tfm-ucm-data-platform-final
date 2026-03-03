#!/usr/bin/env bash
set -euo pipefail

# ==========================================================
# initialize_n8n.sh (RELEASE-ready)
# - Busca credencial Postgres en n8n-db por nombre: chilecompra_postgres
# - Parchea el workflow DEMO para apuntar al ID real de la credencial
# - Importa workflow (idempotente) y exporta evidencia
#
# Requisitos:
# - docker + docker compose
# - python3 en host (para parcheo JSON)
# - Tras `down -v`: crear owner y credencial en UI n8n (1 sola vez)
# ==========================================================

# ---- helpers
log() { echo "[INFO] $*" >&2; }
warn() { echo "[WARN] $*" >&2; }
err() { echo "[ERROR] $*" >&2; }
die() { err "$*"; exit 1; }

need() { command -v "$1" >/dev/null 2>&1 || die "Falta requisito: $1"; }

need docker
need python3
need sed
need grep
need awk
need date

PROJECT_NAME="${PROJECT_NAME:-tfm_demo}"
ENV_FILE="${ENV_FILE:-.env.demo}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

WORKFLOW_JSON="${WORKFLOW_JSON:-deployment/n8n_Worflow/WorkFlowTFM_DEMO.json}"
CRED_NAME="${CRED_NAME:-chilecompra_postgres}"
CRED_TYPE="${CRED_TYPE:-postgres}"

EVD_DIR="deployment/evidence/n8n_bootstrap"
mkdir -p "$EVD_DIR"

# ---- compose files (RELEASE)
COMPOSE_CORE="${COMPOSE_CORE:-docker-compose.portable.yml}"
COMPOSE_N8N="${COMPOSE_N8N:-docker-compose.n8n.yml}"

[[ -f "$ENV_FILE" ]] || die "No existe ENV_FILE=$ENV_FILE (debe estar en el root)"
[[ -f "$COMPOSE_CORE" ]] || die "No existe $COMPOSE_CORE (root del repo)"
[[ -f "$COMPOSE_N8N"  ]] || die "No existe $COMPOSE_N8N (root del repo)"
[[ -f "$WORKFLOW_JSON" ]] || die "No existe WORKFLOW_JSON=$WORKFLOW_JSON"

# ---- detect containers by compose
N8N_CONTAINER="$(docker compose -p "$PROJECT_NAME" --env-file "$ENV_FILE" -f "$COMPOSE_CORE" -f "$COMPOSE_N8N" ps -q n8n || true)"
N8NDB_CONTAINER="$(docker compose -p "$PROJECT_NAME" --env-file "$ENV_FILE" -f "$COMPOSE_CORE" -f "$COMPOSE_N8N" ps -q n8n-db || true)"

if [[ -z "$N8N_CONTAINER" || -z "$N8NDB_CONTAINER" ]]; then
  log "Contenedores n8n no detectados. Levantando stack..."
  docker compose -p "$PROJECT_NAME" --env-file "$ENV_FILE" -f "$COMPOSE_CORE" -f "$COMPOSE_N8N" up -d
  N8N_CONTAINER="$(docker compose -p "$PROJECT_NAME" --env-file "$ENV_FILE" -f "$COMPOSE_CORE" -f "$COMPOSE_N8N" ps -q n8n)"
  N8NDB_CONTAINER="$(docker compose -p "$PROJECT_NAME" --env-file "$ENV_FILE" -f "$COMPOSE_CORE" -f "$COMPOSE_N8N" ps -q n8n-db)"
fi

# Convert to names
N8N_CONTAINER_NAME="$(docker inspect -f '{{.Name}}' "$N8N_CONTAINER" | sed 's#^/##')"
N8NDB_CONTAINER_NAME="$(docker inspect -f '{{.Name}}' "$N8NDB_CONTAINER" | sed 's#^/##')"

log "N8N_CONTAINER=$N8N_CONTAINER_NAME"
log "N8NDB_CONTAINER=$N8NDB_CONTAINER_NAME"
log "WORKFLOW_JSON=$WORKFLOW_JSON"
log "CRED_NAME=$CRED_NAME"
log "CRED_TYPE=$CRED_TYPE"

# ---- wait API (200/401/302)
N8N_PORT="$(grep -E '^N8N_PORT=' "$ENV_FILE" | tail -n1 | cut -d= -f2- | tr -d '\r')"
N8N_PORT="${N8N_PORT:-5678}"
N8N_URL="http://localhost:${N8N_PORT}"

log "Esperando API n8n (200/401/302) en $N8N_URL ..."
ok=0
for i in $(seq 1 90); do
  code="$(curl -s -o /dev/null -w "%{http_code}" "$N8N_URL" || true)"
  if [[ "$code" == "200" || "$code" == "401" || "$code" == "302" ]]; then
    log "API responde (code=$code)."
    ok=1
    break
  fi
  sleep 2
done
[[ "$ok" == "1" ]] || die "Timeout esperando API n8n. Revisa: docker logs $N8N_CONTAINER_NAME --tail 200"

# ---- read credential id from n8n-db
SQL="select id, name, type from credentials_entity where name='${CRED_NAME}' and type='${CRED_TYPE}' limit 1;"
CRED_LINE="$(docker exec "$N8NDB_CONTAINER_NAME" sh -lc "psql -U \"\$POSTGRES_USER\" -d \"\$POSTGRES_DB\" -t -A -c \"$SQL\" 2>/dev/null" || true)"

if [[ -z "$CRED_LINE" ]]; then
  die "NO CONSTA credencial '${CRED_NAME}' (type=${CRED_TYPE}) en n8n-db.
Acción requerida (una sola vez, tras down -v):
  1) Ir a n8n UI: ${N8N_URL}/home/credentials
  2) Crear credencial Postgres con nombre EXACTO: ${CRED_NAME}
     host=chile-pg, port=5432, db=chilecompra, user/pass según .env
  3) Re-ejecutar este script."
fi

CRED_ID="$(echo "$CRED_LINE" | cut -d'|' -f1)"
[[ -n "$CRED_ID" ]] || die "No pude obtener CRED_ID desde n8n-db (line='$CRED_LINE')"
log "CRED_ID=$CRED_ID"

# ---- patch workflow JSON -> temp file
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

PATCHED_JSON="$TMP_DIR/workflow_patched.json"

python3 - <<PY
import json, re
src = r"""$WORKFLOW_JSON"""
dst = r"""$PATCHED_JSON"""
cred_id = r"""$CRED_ID"""
cred_name = r"""$CRED_NAME"""

with open(src, "r", encoding="utf-8") as f:
    data = json.load(f)

# n8n export/import puede ser dict con "nodes" o lista/obj con "data"
# Aquí asumimos que es workflow JSON (dict) con key "nodes"
nodes = data.get("nodes", [])
patched = 0

def patch_node(n):
    global patched
    creds = n.get("credentials")
    if not isinstance(creds, dict):
        return
    pg = creds.get("postgres")
    if isinstance(pg, dict):
        # force id+name
        pg["id"] = cred_id
        pg["name"] = cred_name
        patched += 1

for n in nodes:
    patch_node(n)

# Algunos exports contienen "nodes" dentro de "data"
if not nodes and isinstance(data.get("data"), dict) and isinstance(data["data"].get("nodes"), list):
    nodes = data["data"]["nodes"]
    for n in nodes:
        patch_node(n)

with open(dst, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False)

print(patched)
PY
PATCHED_COUNT="$(tail -n1 <<<"$(python3 - <<PY
import json
# solo para asegurar salida numérica si el bloque anterior no imprime en tu entorno
print("")
PY
)")" 2>/dev/null || true

# Contar patched real con grep (robusto)
PATCHED_NODES="$(grep -o '"credentials"[[:space:]]*:[[:space:]]*{[[:space:]]*"postgres"' -n "$PATCHED_JSON" | wc -l | tr -d ' ')"
log "Patched nodes with postgres credential: ${PATCHED_NODES}"

# ---- import workflow (idempotente: n8n decide por name/id)
log "Importando workflow parcheado..."
docker cp "$PATCHED_JSON" "${N8N_CONTAINER_NAME}:/tmp/workflow_patched.json"
docker exec "$N8N_CONTAINER_NAME" sh -lc "n8n import:workflow --input=/tmp/workflow_patched.json >/dev/null"
log "Workflow importado"

# ---- export evidence
log "Exportando evidencia workflows_all.json ..."
docker exec "$N8N_CONTAINER_NAME" sh -lc "n8n export:workflow --all --output=/tmp/workflows_all.json >/dev/null"
docker cp "${N8N_CONTAINER_NAME}:/tmp/workflows_all.json" "${EVD_DIR}/workflows_all.json"
log "Evidencia exportada: ${EVD_DIR}/workflows_all.json"

log "DONE"
