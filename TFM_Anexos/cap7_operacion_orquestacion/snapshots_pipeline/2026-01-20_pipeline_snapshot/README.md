# Fase 5 — Cierre (Snapshot técnico del pipeline)

**Fecha del snapshot:** 2026-01-20  
**Ubicación:** `docs/evidence/fase5_cierre/2026-01-20_pipeline_snapshot/`

## 1. Propósito

Este directorio conserva un **snapshot técnico** del estado del stack (Docker + ETL + DW)
y de métricas de control asociadas a la ejecución por período.  
Su objetivo es aportar **trazabilidad reproducible** y evidencia de control operativo para la memoria UCM.

## 2. Qué contiene (evidencia)

Carpeta: `fase5_cierre_2026-01-20/`

- `00_timestamp.txt`: marca temporal del snapshot.
- `01_docker_ps.txt`: estado de contenedores al momento del snapshot.
- `02_etl_control_cargas_full.txt`: extracto de control de cargas (DW).
- `03_etl_decisiones_periodo_full.txt` + `03b_noop_periodos_controlados.txt`: decisiones por período (incluye NO-OP cuando aplica).
- `04_fact_licitaciones_por_periodo.txt` / `05_fact_oc_por_periodo.txt`: conteos por período (LIC/OC).
- `06_dup_lic_por_periodo.txt` / `07_dup_oc_por_periodo.txt`: señales de duplicidad por período.
- `08_sentinel_oc_por_periodo.txt`: sentinel / controles específicos OC.
- `09_percentiles_oc_por_periodo.txt`: percentiles OC por período.
- `10_inbox_lic_tree.txt` / `11_inbox_oc_tree.txt` / `12_inbox_files_por_periodo.txt`: inventario de archivos de entrada por período.
- `13_fk_nulls_lic_por_periodo.txt` / `14_fk_nulls_oc_por_periodo.txt`: controles de integridad (FK nulls).
- `13a_desc_fact_licitaciones.txt` / `13b_desc_fact_ordenes_compra.txt` / `13c_columns_facts.txt`: descripción estructural de facts.
- `15_dim_counts.txt`: conteos de dimensiones relevantes.

## 3. Qué NO contiene (decisión de publicación)

- No incluye Data Lake ni datos crudos.
- No incluye backups de bases de datos ni artefactos sensibles.
- No incluye secretos (`.env`, API keys, tokens).

## 4. Cómo regenerar (alto nivel)

Este snapshot es **evidencia**, no un “output obligatorio” del pipeline.

La regeneración se basa en:

1) levantar stack (`docker compose ... up -d`),
2) ejecutar ETL del período,
3) ejecutar consultas de control equivalentes.

> Referencia operacional: `docs/` (arquitectura, metodología y estado del proyecto).
