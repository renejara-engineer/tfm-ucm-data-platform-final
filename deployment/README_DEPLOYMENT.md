
# Deployment — ChileCompra Data Platform (RELEASE / DEMO)

Universidad Complutense de Madrid (UCM)  
Máster de Formación Permanente en DATA SCIENCE, BIG DATA & BUSINESS ANALYTICS  
TFM — Anexo Digital Reproducible  

---

## 1. Propósito del Directorio

El directorio `deployment/` contiene los **scripts oficiales de ejecución reproducible** del entorno RELEASE (DEMO).

Su objetivo es permitir que, desde un clon limpio del repositorio, el sistema:

- Levante el stack Docker completo.
- Ejecute el período DEMO controlado.
- Valide estructura del Data Warehouse.
- Genere evidencia técnica persistente.
- Demuestre idempotencia de carga.

Este directorio no contiene lógica de negocio ni código ETL.  
Contiene únicamente mecanismos de orquestación técnica y validación.

---

## 2. Archivos Principales

### 2.1 run_demo.sh

Script principal de ejecución reproducible.

Responsabilidades:

1. Validación de variables de entorno.
2. Levantamiento idempotente del stack Docker.
3. Verificación de salud del servicio ETL.
4. Validación de archivos INBOX DEMO.
5. Ejecución del endpoint `/run_period`.
6. Verificación de `dw.etl_control_cargas`.
7. Validación de tablas `dw.*`.
8. Validación de vistas `dw_sem.*`.
9. Persistencia de evidencia en disco.

Ejecución oficial:

```text
PROJECT_NAME=tfm_demo ENV_FILE=.env.demo bash deployment/run_demo.sh
```

---

### 2.2 initialize_n8n.sh

Script auxiliar para:

- Importar workflow DEMO en n8n.
- Parchear credencial Postgres si corresponde.
- Asegurar coherencia tras pruning total.

Se ejecuta únicamente si se requiere reconstrucción de n8n.

---

### 2.3 evidence/

Directorio donde se almacenan las ejecuciones.

Estructura:

```text
deployment/evidence/DEMO/<timestamp>/
```

Incluye:

- Logs de ejecución.
- Validaciones SQL.
- Estado de `dw.etl_control_cargas`.
- Listado de objetos `dw` y `dw_sem`.
- Logs ETL.
- Logs n8n.

La evidencia generada constituye soporte técnico verificable.

---

## 3. Flujo Operativo DEMO

### 3.1 Escenario A --- Ejecución Terminal (FastAPI directo)

``` bash
bash deployment/run_demo.sh
```

### El script realiza ':'

- Validación entorno\
- Levantamiento stack\
- Healthcheck ETL\
- Ejecución `/run_period`\
- Validación DW\
- Validación capa semántica\
- Generación de evidencia

> Este escenario **no depende de n8n**.

---

### 3.2 Escenario B --- Orquestación con n8n

#### Inicialización (si necesario)

``` bash
bash deployment/initialize_n8n.sh
```

#### Ejecución

Acceder a:

    http://localhost:5678

Ejecutar workflow **DEMO**.

Verificar tablas en PostgreSQL.

### 3.3 Reconstrucción total

(Válido para ambos escenarios)

``` bash
docker compose -p tfm_demo down -v
docker volume prune -f

bash deployment/run_demo.sh
```

---

## 4. Idempotencia

Si el período DEMO ya fue procesado correctamente, el script mostrará:

```text
[SKIP] 2024-09 ya OK en dw.etl_control_cargas
```

Este comportamiento es intencional y forma parte del diseño técnico.

---

## 5. Alcance

Este directorio:

- No contiene datos históricos masivos.
- No contiene credenciales reales. Incluye únicamente valores DEMO en .env.demo.example para
  ejecución local reproducible (deben cambiarse si se despliega fuera del entorno local)..
- No modifica la arquitectura del sistema.
- No altera el esquema del Data Warehouse.

Su función es exclusivamente demostrar reproducibilidad técnica controlada.

---

## 6. Declaración Final

El directorio `deployment/` materializa el principio central del TFM:

> Reproducibilidad técnica verificable bajo condiciones controladas.

Su diseño prioriza claridad operativa, trazabilidad y consistencia académica.
