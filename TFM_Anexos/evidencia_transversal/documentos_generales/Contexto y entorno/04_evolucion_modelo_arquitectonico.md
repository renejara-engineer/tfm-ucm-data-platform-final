# Evolucion Modelo Arquitectonico – TFM ChileCompra Data Platform

Este documento describe el proceso evolutivo del modelo arquitectónico, desde el enfoque Lakehouse inicial hacia la arquitectura gobernada implementada actualmente.

---

## Arquitectura general

- Punto central: `docker-compose.yml` define servicios de:
  - **PostgreSQL** (data warehouse).
  - **ETL** en Python (`etl/Dockerfile`, `etl/app.py`).
  - **n8n** para orquestación (archivos bajo `n8n/`).
- El **Data Lake (RAW → CLEAN → MART)** vive en un **disco externo** y NO se versiona. Rutas y nombres se configuran vía `.env` y `config.yaml`.
- SQL de esquema y semillas en `db/init/*.sql` (tablas de hechos/dimensiones para LP, OC y organismos).

---

## Flujo de datos

1. Fuentes externas ChileCompra (API + CSV mensuales LP/OC).
2. Ingesta en capas RAW (scripts en `scripts/etl/` y módulo `etl/chilecompra/api_client.py`).
3. Transformaciones a CLEAN (`transform.py` y scripts `*_raw_to_clean.py`).
4. Carga a MART/DW (`load.py`, scripts `etl_consolidate_*.py`) hacia PostgreSQL.
5. Consumo analítico desde BI (fuera de este repo).

---

## Workflows de desarrollo

- Configuración de entorno: usar `.env.example` como plantilla y **no versionar `.env` reales**.
- Scripts shell principales en la raíz:
  - `01-init_env.sh`, `02-tfm.sh`, `05-datalake_simple.sh`, `setup.sh` y `arbol.sh` automatizan levantamiento de contenedores, inicialización de esquema y creación del árbol de Data Lake.
- Para añadir nuevos pasos de ETL:
  - Preferir crear scripts en `scripts/etl/` o funciones nuevas en `etl/chilecompra/*.py` antes que mezclar lógica en `app.py`.
  - Mantener el patrón **extract → transform → load** claramente separado.

---

## Convenciones del artefactos

- Los directorios de datos (`DataLake_RAW/`, `DataLake_Clean/`, `DataLake_Mart/`, `Logs/`, etc.) y ficheros pesados (`*.csv`, `*.xlsx`, `*.parquet`, `*.json`, `*.zip`) están **ignorados en `.gitignore`**.
- Toda configuración sensible (claves API, rutas del disco externo, credenciales de DB) va en `.env` y/o `config.yaml`; usar variables de entorno en el código.
- Cuando se genere código nuevo:
  - Usar rutas relativas y `pathlib` en lugar de paths hardcodeados.
  - Pensar siempre en ejecución dentro de contenedores Docker (paths de volumen, hosts de base de datos).
- La documentación técnica vive en `docs/` (por ejemplo `docs/architecture.md`); mantenerla alineada con cambios de arquitectura.

---
