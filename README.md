
# 📌 TFM — Diseño e implementación de un sistema ETL automatizado para la integración y análisis de datos abiertos de contratación pública

**Universidad Complutense de Madrid (UCM)**  
**Máster de Formación Permanente en Data Science, Big Data & Business Analytics**  
**Trabajo Fin de Máster (TFM)**  

**Autor:** Rene Jara Balboa  
**Repositorio técnico reproducible (Anexo digital del informe TFM)**  

## 1. Naturaleza del Repositorio

El presente repositorio constituye el **anexo digital reproducible oficial** del Trabajo Fin de Máster.

Su propósito no es el desarrollo incremental (DEV), sino demostrar, desde un **clon limpio**, que la arquitectura propuesta:

- Es técnicamente reproducible.
- Es idempotente.
- Es verificable mediante evidencia en terminal.
- Cumple separación entre capas (ETL → DW → Capa Semántica).
- Es portable (sin dependencias de rutas absolutas locales).
- Es evaluable por tribunal académico.

Esta versión corresponde exclusivamente al entorno **RELEASE (DEMO)**.

---

## 2. Alcance Técnico Demostrado

La ejecución controlada permite:

1. Levantar stack Docker completo.
2. Inicializar Data Warehouse (PostgreSQL 15).
3. Ejecutar ETL vía endpoint HTTP `/run_period`.
4. Registrar control de cargas en `dw.etl_control_cargas`.
5. Materializar vistas semánticas `dw_sem`.
6. Generar evidencia reproducible de la ejecución.

---

## 3. Arquitectura General

Data Lake (INBOX)\
→ ETL (FastAPI en Docker)\
→ PostgreSQL (DW + DW_SEM)\
→ n8n (orquestación HTTP)\
→ Evidencia reproducible

---

## 4. Estructura Principal del Repositorio

Presentación estructurada siguiendo convenciones habituales de proyectos
open-source en GitHub:

```text
chilecompra-platform/
    │
    ├── data/                  # Data Lake DEMO (estructura mínima)
    ├── db/                    # Inicialización DW y vistas semánticas
    ├── etl/                   # Servicio ETL (FastAPI)
    ├── deployment/            # Scripts oficiales de ejecución DEMO
    ├── docs/                  # Documentación técnica ligera
    ├── TFM_Anexos/            # Anexo académico del informe TFM
    │
    ├── docker-compose.yml
    ├── docker-compose.portable.yml
    ├── docker-compose.n8n.yml
    │
    └── README.md
```

---

### 🔹 data/

Contiene la estructura del Data Lake en versión DEMO.\
No incluye datasets históricos masivos.

---

### 🔹 db/

Scripts SQL para:

- Creación de esquemas (dw, dw_sem)
- Tablas de hechos y dimensiones
- Índices y constraints
- Vistas semánticas

Permite reconstrucción completa del DW desde cero.

---

### 🔹 etl/

Servicio FastAPI responsable de:

- Endpoint `/health`
- Endpoint `/run_period`
- Transformación y carga al DW
- Registro en tabla de control

---

### 🔹 deployment/

Contiene los scripts oficiales:

- `run_demo.sh` → ejecución terminal-first reproducible\
- `initialize_n8n.sh` → importación y configuración de workflow n8n

La evidencia se genera en:

    deployment/evidence/DEMO/{timestamp}/

---

### 🔹 docs/

Documentación técnica asociada a la versión RELEASE.

---

### 🔹 TFM_Anexos/

Material académico complementario:

- Notebooks históricos
- Evidencias extendidas
- Análisis exploratorios

No es dependencia operativa del pipeline DEMO.

---

**La estructura refleja separación clara entre**:

- Datos (DEMO)
- Inicialización DW
- Servicio ETL
- Orquestación y despliegue
- Evidencia técnica
- Material académico complementario

---

## 5. Estándar de Datos DEMO

Los archivos CSV utilizados en esta versión DEMO:

- Utilizan delimitador `;` (punto y coma).
- Mantienen estructura consistente entre LIC y OC.
- Son procesados explícitamente bajo este estándar por el ETL.

No existe ambigüedad de delimitador en la versión RELEASE.

---

## 6. Escenarios de Ejecución DEMO

La plataforma puede ejecutarse bajo dos escenarios controlados:

---

### 6.1 Escenario A --- Ejecución directa vía FastAPI (Terminal-First)

Este escenario demuestra la ejecución técnica mínima del pipeline sin
orquestación externa.

#### Paso 1 --- Clon limpio

``` bash
git clone https://github.com/renejara-engineer/tfm-ucm-data-platform-final.git
cd tfm-ucm-data-platform-final
```

#### Paso 2 --- Garantizar estado cero

>> (Opcional para verificacion de estado inicial y final de estados)*

``` bash
docker compose -p tfm_demo down -v || true
docker volume ls | grep tfm_demo || echo "OK: no demo volumes"
```

#### Paso 3 --- Ejecución reproducible

``` bash
bash deployment/run_demo.sh
```

#### Este flujo realiza':'

- Levanta PostgreSQL 15\
- Levanta servicio ETL (FastAPI)\
- Valida endpoint `/health`\
- Ejecuta endpoint `/run_period`\
- Registra control en `dw.etl_control_cargas`\
- Materializa tablas y vistas\
- Genera evidencia técnica

#### Arquitectura en este escenario

Data Lake → FastAPI (ETL) → PostgreSQL (DW + dw_sem)

---

### 6.2 Escenario B --- Orquestación vía n8n

Este escenario demuestra la integración del ETL dentro de un sistema de
automatización.

#### Flujo de ejecución

n8n → HTTP → FastAPI (/run_period) → PostgreSQL

#### Inicialización

>> (Si es primera ejecución o tras pruning total)*

``` bash
bash deployment/initialize_n8n.sh
```

Este script:

- Importa el workflow DEMO\
- Configura credencial PostgreSQL\
- Garantiza coherencia del entorno n8n

#### Ejecución vía UI n8n

Acceder a:

http://localhost:5678

Ejecutar el workflow **DEMO**.

---

#### Verificación en base de datos

``` sql
SELECT * FROM dw.etl_control_cargas;
```

### 6.3 Comparación conceptual

| Aspecto           | Escenario A                          | Escenario B                         |
|-------------------|--------------------------------------|-------------------------------------|
| Punto de entrada  | Terminal                             | UI n8n                             |
| Trigger           | Script bash                          | Workflow                           |
| Llamada ETL       | HTTP local                           | HTTP local                         |
| Registro DW       | Sí                                   | Sí                                 |
| Evidencia         | Automática                           | Automática                         |
| Objetivo          | Validación técnica mínima            | Validación de orquestación         |

---

## 7. Reconstrucción Total (Pruning Controlado)

Para validar independencia de estado previo:

```text
docker compose -p tfm_demo down -v
docker volume prune -f
docker container prune -f
docker network prune -f

PROJECT_NAME=tfm_demo ENV_FILE=.env.demo bash deployment/run_demo.sh
```

El sistema debe reconstruirse sin intervención manual.

---

## 8. Idempotencia

Si el período ya fue procesado correctamente:

```text
[SKIP] 2024-09 ya OK en dw.etl_control_cargas
```

Este comportamiento es intencional y forma parte del diseño técnico.

---

## 9. Evidencia Generada

Cada ejecución documenta:

- Esquemas (`\dn`)
- Tablas DW (`\dt dw.*`)
- Vistas `dw_sem`
- Conteos de tablas fact
- Estado de `dw.etl_control_cargas`
- Logs ETL
- Logs n8n

La evidencia es trazable y verificable.

---

## 10. Declaración Final

Este repositorio no es un entorno de desarrollo.

Es una **pieza académica reproducible**, diseñada para evaluación técnica formal.

El entorno DEV (REAL) histórico no forma parte de esta entrega.

El objetivo de esta versión es demostrar consistencia arquitectónica, control de carga, separación de capas y reproducibilidad técnica bajo condiciones controladas.
