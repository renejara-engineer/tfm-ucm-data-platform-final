# Anexo Cap. 4 — Extracción y normalización

Este anexo consolida el material técnico asociado al Capítulo 4 del informe
(Extracción, normalización y preparación de datos).

## 1. Estructura de entrada (INBOX)
La recepción de datos se organiza en un Data Lake particionado por período,
disponible en el repositorio bajo:
- data/ChileCompraDL/00_INBOX/

## 2. Proceso ETL de extracción y normalización
El pipeline de extracción y normalización se implementa en el contenedor ETL
y su código se encuentra en:
- etl/
- etl/pipelines/ (pipeline por período)
- etl/sql_templates/ (plantillas de validación y control)

## 3. Evidencia técnica de normalización
La evidencia relacionada con perfiles de estructura, volumetría y consistencia
de capas INBOX/STG se documenta en los anexos de gobierno de datos:
- TFM_Anexos/cap6_gobierno_datos/ (EDA y hallazgos de calidad)

## 4. Relación con capítulos posteriores
El resultado de esta fase alimenta:
- Cap. 5 (Modelo dimensional en PostgreSQL)
- Cap. 6 (Gobierno de datos y controles)
- Cap. 7 (Operación reproducible y orquestación)