# Estado Oficial del Pipeline y Data Warehouse

TFM: **ChileCompra Data Platform**  
Universidad: **Universidad Complutense de Madrid (UCM)**  
Modalidad: Plataforma reproducible local (Docker + PostgreSQL + n8n)

---

## 1. Naturaleza del documento

El presente documento declara el **estado técnico consolidado del pipeline productivo y del Data Warehouse (DW)**. Ademas, complementa la arquitectura técnica y académica definida en los documentos fundacionales, declarando el estado consolidado del sistema implementado.

Constituye la referencia oficial sobre:

- Alcance temporal procesado.
- Arquitectura efectiva de carga.
- Control de calidad y decisiones registradas.
- Estabilidad del modelo analítico.
- Condiciones de transición hacia la capa de explotación BI.

En caso de discrepancia con documentación operativa o bitácoras históricas, este documento prevalece como fuente oficial del estado técnico del sistema.

---

## 2. Alcance temporal procesado y validado

Los siguientes periodos han sido procesados completamente mediante el pipeline productivo, con validación SQL reproducible en:

- `dw.etl_control_cargas`
- `dw.fact_licitaciones`
- `dw.fact_ordenes_compra`

| Periodo  | LIC (DW) | OC (DW)  | Estado |
|----------|----------|----------|--------|
| 2024-09  | 147.755  | 324.419  | OK     |
| 2024-10  | 199.155  | 477.995  | OK     |
| 2024-11  | 475.782  | 429.335  | OK     |
| 2024-12  | 312.983  | 373.131  | OK     |
| 2025-02  | 452.154  | 316.147  | OK     |
| 2025-04  | 494.536  | 405.677  | OK     |
| 2025-05  | 470.000  | 376.060  | OK     |
| 2025-06  | 407.938  | 372.131  | OK     |
| 2025-07  | 372.640  | 382.670  | OK     |
| 2025-08  | 358.505  | 371.035  | OK     |
| 2025-09  | 265.167  | 340.311  | OK     |
| 2025-10  | 190.988  | 387.901  | OK     |

### Validaciones aplicadas en todos los periodos

- Consistencia entre tablas STG y DW.
- Unicidad por `(business_key, periodo)`.
- Ausencia de valores centinela monetarios anómalos (`>= 999e12`).
- Percentiles monetarios razonables.
- Integridad referencial documentada (NULLs aceptados y justificados).
- Registro formal de carga en `dw.etl_control_cargas`.

El Data Warehouse se considera consistente y auditado para los periodos indicados.

---

## 3. Gestión explícita de anomalías de fuente

El pipeline incorpora control estructural y de volumen previo a la carga en DW.

Los siguientes periodos no fueron cargados por decisión controlada:

| Periodo  | Situación detectada                                               | Decisión         | Registro                    |
|----------|-------------------------------------------------------------------|------------------|-----------------------------|
| 2025-01  | Archivo LIC estructuralmente anómalo (estructura mínima inválida) | EXCEPCION_FUENTE | `dw.etl_decisiones_periodo` |
| 2025-03  | Archivo OC con volumen insuficiente (13 KB / 187 filas)           | NO_OP            | `dw.etl_decisiones_periodo` |

Estas decisiones no representan fallos del sistema, sino aplicación explícita de reglas de gobernanza y control de calidad de datos.

---

## 4. Arquitectura efectiva del pipeline productivo

### 4.1 Entrada

Archivos CSV mensuales ubicados en:

/data_lake/00_INBOX/{LIC|OC}/{YYYY-MM}/

### 4.2 Zona STG (Staging)

- Creación dinámica de tablas:
  - `stg_lic_YYYY_MM`
  - `stg_oc_YYYY_MM`
- Carga idempotente.
- Validaciones estructurales previas a consolidación.

### 4.3 Data Warehouse (DW)

Tablas principales:

- `dw.dim_fecha`
- `dw.fact_licitaciones`
- `dw.fact_ordenes_compra`

Tablas de control:

- `dw.etl_control_cargas`
- `dw.etl_decisiones_periodo`

La carga es idempotente y controlada por periodo.

### 4.4 Orquestación y ejecución

Ejecución reproducible:

```bash
docker compose exec -T etl \
  sh -lc 'python /app/run_period.py --period YYYY-MM'
```

Componentes clave:

- etl/run_period.py
- etl/cli_monthly.py
- etl/sql_templates/*.template.sql
- Registro de estado en PostgreSQL.

El sistema opera en modalidad batch mensual.

## 5. Estado técnico actual

El pipeline productivo se encuentra:

- Estable.
- Reproducible.
- Idempotente.
- Auditado.
- Documentado.

No se contemplan modificaciones estructurales adicionales al Data Warehouse previo al desarrollo y consolidación de la capa de explotación analítica.

## 6. Relación con la capa de explotación analítica

El Data Warehouse constituye la base estable para:

- Contrato analítico validado.
- Modelado dimensional.
- Implementación de KPIs.
- Visualización en Power BI.

La capa BI se apoya en un DW consistente y no depende de ejecución en tiempo real del ETL.

## 7. Limitaciones documentadas

Integración vía API oficial no implementada por ausencia de credenciales externas.

Dependencia de archivos CSV mensuales como fuente oficial.

Modelo orientado a batch histórico y no a streaming.

Estas limitaciones no comprometen la coherencia técnica ni la validez analítica del modelo implementado.

## 8. Declaración final

La plataforma ChileCompra Data Platform dispone de un pipeline productivo consolidado, con trazabilidad explícita desde STG hasta DW, control formal de decisiones de carga y base técnica suficiente para explotación analítica estructurada.

Este documento representa el estado oficial del sistema en su configuración consolidada.
