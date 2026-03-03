# Verificación n8n – 2026-02-15  

**Registro de evidencia técnica (UCM) – estado, persistencia y reproducibilidad**

## 1. Propósito (enfoque académico UCM)

Este directorio constituye un **registro de verificación reproducible** del componente **n8n** utilizado en el TFM.

Su finalidad es dejar evidencia objetiva (audit trail) de que el stack **n8n + base de datos Postgres**:

- está **operativo** (servicio disponible y accesible),
- conserva **persistencia de datos** (usuarios y workflows almacenados en volúmenes),
- utiliza una configuración **coherente y estable** (variables críticas consistentes),
- y permite **reproducción por terceros** (tribunal o lector externo) mediante comandos verificables.

> En un TFM UCM, este tipo de carpeta se justifica como **evidencia de continuidad del entorno** y soporte de trazabilidad técnica, no como documentación funcional del workflow.

---

## 2. Alcance de esta verificación

Verificación puntual del stack levantado mediante:

- `docker-compose.n8n.portable.yml`  
- contenedores: `tfm_ucm-n8n-1` y `tfm_ucm-n8n-db-1`

Se validó específicamente:

- disponibilidad del servicio n8n (UI),
- conectividad DB,
- existencia de usuario owner,
- existencia de workflows registrados,
- configuración runtime y mounts (persistencia).

Fuera de alcance:

- ejecución de workflows,
- ejecución de ETL ChileCompra,
- validaciones DW/BI,
- pruebas de rendimiento o seguridad avanzada.

---

## 3. Evidencias generadas (inventario de archivos)

Archivos contenidos en:

`docs/evidence/n8n/2026-02-15_Verificacion/`

### 3.1 Evidencia de usuario / ownership

- `db_user_owner.txt`  
  Consulta SQL de la tabla `public.user` validando la existencia de usuario con rol `global:owner`.  
  **Objetivo:** demostrar que el stack tiene usuario administrador válido y persistente.

- `db_user_list.txt`  
  Listado general de usuarios existentes (si aplica).  
  **Objetivo:** evidenciar si existen cuentas adicionales por migraciones o pruebas.

### 3.2 Evidencia de workflows existentes

- `db_workflows_list.txt`  
  Consulta SQL sobre `public.workflow_entity` mostrando workflows existentes.  
  **Objetivo:** confirmar continuidad del artefacto principal del TFM (ej. workflow `TFM_ver6.0`).

### 3.3 Evidencia de disponibilidad del servicio

- `logs_n8n_tail200.txt`  
  Logs recientes del contenedor `n8n`.  
  **Objetivo:** evidenciar estado “ready”, puerto expuesto y reinicios controlados si existiesen.

- `logs_n8n_db_tail200.txt`  
  Logs recientes del contenedor Postgres (`n8n-db`).  
  **Objetivo:** evidenciar que la base está operativa y aceptando conexiones.

### 3.4 Evidencia de configuración runtime (sin secretos)

- `runtime_env_public.txt`  
  Variables relevantes para reproducibilidad (host/port/urls/timezone/DB host).  
  **Objetivo:** dejar constancia del wiring del servicio y parámetros no sensibles.

- `runtime_env_critical.txt` *(si aplica)*  
  Variables críticas capturadas de forma controlada (sin exponer claves en GitHub).

- `runtime_userfolder_config.txt`  
  Evidencia de `N8N_USER_FOLDER` y archivo de configuración cargado por n8n.  
  **Objetivo:** confirmar ruta de persistencia local de configuración.

### 3.5 Evidencia de mounts y volúmenes (persistencia)

- `docker_mounts_n8n.json`  
  Mounts del contenedor `n8n` (volúmenes y binds).

- `docker_mounts_n8n_db.json`  
  Mounts del contenedor `n8n-db`.

**Objetivo:** demostrar que el stack usa volúmenes persistentes (no datos efímeros).

### 3.6 Carpeta de exports

- `exports/`  
  Carpeta reservada para exportar workflows/credenciales (si se requiere evidencia adicional).

---

## 4. Protocolo de verificación (qué se comprobó)

La verificación se planteó como un conjunto de hipótesis comprobables mediante evidencia directa.

### Check 1 – Servicio n8n disponible

- n8n alcanza estado `ready`.
- UI accesible en: `http://localhost:5678/`

Evidencia:

- `logs_n8n_tail200.txt`
- (opcional) captura de pantalla UI.

### Check 2 – Base de datos operativa

- Postgres se encuentra activo y acepta conexiones.

Evidencia:

- `logs_n8n_db_tail200.txt`

### Check 3 – Owner existente

- Existe usuario con rol `global:owner` en tabla `public.user`.

Evidencia:

- `db_user_owner.txt`

### Check 4 – Workflows existentes

- Existe al menos el workflow principal del TFM (`TFM_ver6.0`).

Evidencia:

- `db_workflows_list.txt`

### Check 5 – Persistencia correcta

- Los contenedores utilizan volúmenes persistentes declarados como mounts.

Evidencia:

- `docker_mounts_n8n.json`
- `docker_mounts_n8n_db.json`

---

## 5. Resultados (redacción neutral estilo tribunal)

Resultado de verificación según evidencia generada:

- **Estado del servicio:** n8n operativo y accesible vía UI.
- **Owner:** presente (`global:owner`) con email del autor del TFM.
- **Workflows:** existe al menos 1 workflow registrado (`TFM_ver6.0`).
- **Persistencia:** mounts y volúmenes registrados; el stack opera con datastore persistente.

> Nota: la evidencia de esta carpeta es suficiente para justificar continuidad técnica del componente n8n dentro del ecosistema del TFM.

---

## 6. Condiciones técnicas observadas (controladas para reproducibilidad)

### Condición C-N8N-01: precedencia de variables del host

En Docker Compose, una variable exportada en el host puede tener prioridad sobre valores declarados en `--env-file`.

Caso crítico:

- `N8N_ENCRYPTION_KEY` exportada en el host puede sobrescribir `.env.local`.

Impacto:

- riesgo de error por claves inconsistentes (encryption mismatch),
- riesgo de que el stack arranque con configuración diferente a la esperada.

Control aplicado:

- levantar el stack sin heredar esa variable del host.

Ejemplo de ejecución controlada:

```bash
env -u N8N_ENCRYPTION_KEY docker compose -f docker-compose.n8n.portable.yml --env-file .env.local up -d
```

Este punto se incluye como parte de la documentación técnica porque mejora la reproducibilidad del entorno ante revisión externa.

---

## 7. Comandos de reproducción (mínimos)

> Ajustar nombres de contenedor si varían en otros entornos.

### 7.1 Estado de contenedores

```bash
docker ps -a --filter name=tfm_ucm-n8n --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}'
```

### 7.2 Logs (captura corta)

```bash
docker logs --tail=200 tfm_ucm-n8n-1 > docs/evidence/n8n/2026-02-15_Verificacion/logs_n8n_tail200.txt
docker logs --tail=200 tfm_ucm-n8n-db-1 > docs/evidence/n8n/2026-02-15_Verificacion/logs_n8n_db_tail200.txt
```

### 7.3 Owner (tabla user)

```bash
docker exec tfm_ucm-n8n-db-1 sh -lc 'psql -X -q -U n8n -d n8n -P pager=off -c "select id, email, \"firstName\", \"lastName\", role from public.\"user\";"' > docs/evidence/n8n/2026-02-15_Verificacion/db_user_owner.txt
```

### 7.4 Workflows (lista oficial)

```bash
docker exec tfm_ucm-n8n-db-1 sh -lc 'psql -X -q -U n8n -d n8n -P pager=off -c "select id, name, active, \"updatedAt\" from public.workflow_entity order by \"updatedAt\" desc limit 50;"' > docs/evidence/n8n/2026-02-15_Verificacion/db_workflows_list.txt
```

### 7.5 Mounts (reproducibilidad de persistencia)

```bash
docker inspect tfm_ucm-n8n-1 --format '{{json .Mounts}}' > docs/evidence/n8n/2026-02-15_Verificacion/docker_mounts_n8n.json
docker inspect tfm_ucm-n8n-db-1 --format '{{json .Mounts}}' > docs/evidence/n8n/2026-02-15_Verificacion/docker_mounts_n8n_db.json
```

---

## 8. Organización recomendada de evidencia (GitHub / tribunal)

Para evitar mezcla de evidencias de distintas fechas:

- Mantener la convención:  
  `docs/evidence/n8n/<YYYY-MM-DD>_<Etiqueta>/`
- Generar archivos `.zip` dentro de la carpeta fechada o en `exports/`.
- Evitar dejar `.zip` sueltos en el nivel superior `docs/evidence/n8n/`.

Esto asegura que cada carpeta fechada sea un bloque autocontenido, legible y verificable.

---

## 9. Evidencia n8n — 2026-02-15 (Verificación pública)

### 9.1. Objetivo

Documentar evidencia mínima y reproducible de la capa de orquestación (n8n) usada en el TFM.

### 9.2. Evidencia incluida

- `docker_mounts_n8n.json` / `docker_mounts_n8n_db.json`: evidencia de mounts y volúmenes en runtime.
- `workflow_entity_tail15.txt`: evidencia SQL de existencia del workflow en la BD de n8n.
- `exports/TFM_WorkFlow.json`: export del workflow (importable en n8n UI).
- `exports/TFM_WorkFlow.sha256`: hash para trazabilidad del export.

### 9.3. Workflow verificado

- Name: `TFM_ver6.0`
- ID: `gHLhuJpDimL6Fw71`
- Activación: manual (inactive=false en DB; ejecución vía `Manual Trigger`).

### 9.4. Nota de reproducibilidad

El repositorio público incluye un modo DEMO con dataset acotado. El modo REAL utiliza un Data Lake externo (no publicable por tamaño).

---
