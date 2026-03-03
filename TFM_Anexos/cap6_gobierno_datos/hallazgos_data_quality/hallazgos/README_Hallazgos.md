# 📦 ChileCompra Data Platform

## Build de Hallazgos Técnicos --- 2025-12-15

------------------------------------------------------------------------

## 1. Descripción General

El archivo `2025-12-15_build_hallazgos.zip` contiene el paquete
consolidado de hallazgos técnicos, métricas de calidad, análisis
estructural y evidencia formal generada a partir del análisis de
datasets reales de ChileCompra (LIC, OC y Organismos Compradores).

Este build representa un punto de control técnico dentro del proyecto
**ChileCompra Data Platform (UCM)** y documenta de forma verificable:

- Calidad estructural de los datos
- Relaciones reales entre entidades
- Anomalías detectadas
- Métricas cuantitativas
- Decisiones de modelado derivadas

No es solo un conjunto de archivos técnicos: es evidencia de ingeniería
aplicada al diseño del Data Warehouse.

------------------------------------------------------------------------

## 2. Propósito

Este paquete tiene como objetivo:

1. Respaldar técnicamente el diseño del modelo dimensional.
2. Proveer evidencia objetiva para justificar decisiones
   arquitectónicas.
3. Validar relaciones reales entre LIC ↔ OC ↔ Organismos.
4. Identificar limitaciones estructurales del negocio.
5. Detectar riesgos analíticos antes de la explotación BI.
6. Documentar hallazgos críticos surgidos en Fase 5.

En términos académicos y profesionales:

> Demuestra trazabilidad entre datos reales, modelado y decisiones
> técnicas.

------------------------------------------------------------------------

## 3. Contenido del Paquete

### 3.1 Profiling y Diccionarios

- ORG_profiles.jsonl\
- LIC_profiles.jsonl\
- OC_profiles.jsonl\
- ORG_dict.md\
- LIC_dict.md\
- OC_dict.md

Incluyen: - Tipos de datos detectados - Cardinalidades - Valores nulos -
Distribuciones - Diccionario técnico-documental de campos

------------------------------------------------------------------------

### 3.2 Inventarios y Resúmenes

- raw_inventory_lic.csv\
- raw_inventory_oc.csv\
- LIC_file_summary.csv\
- OC_file_summary.csv\
- ORG_summary.csv

Permiten verificar volumen por mes, consistencia estructural y posibles
archivos incompletos.

------------------------------------------------------------------------

### 3.3 Relaciones Entre Datasets

- relationships_metrics.json\
- relationships_examples.csv

Contienen métricas de intersección, cardinalidades reales y evidencia
empírica de vinculación entre entidades.

------------------------------------------------------------------------

### 3.4 Calidad y Duplicidades

- quality_gates_summary.csv\
- inter_month_repeated_hashes_LIC.csv\
- inter_month_repeated_hashes_OC.csv\
- dups.duckdb

Incluyen controles de duplicados y consistencia temporal.

------------------------------------------------------------------------

### 3.5 Hallazgos Consolidados

- indicadores.json\
- findings.json

Documentan métricas agregadas y problemas estructurales detectados.

------------------------------------------------------------------------

### 3.6 Diseño y Recomendaciones

- postgres_design_notes.md\
- postgres_recommendations.sql\
- run_config.json\
- readme_build_log.txt

Incluyen decisiones físicas de modelado y registro de ejecución.

------------------------------------------------------------------------

## 4. Resultados Obtenidos

El análisis permitió:

- Confirmar que LIC y OC no tienen relación 1:1.
- Detectar múltiples proveedores por licitación.
- Identificar adjudicaciones parciales y progresivas.
- Evidenciar desalineación temporal entre LIC y OC.
- Detectar duplicados inter-mensuales.

Resultado clave:

> El modelo inicial técnicamente correcto no representaba completamente
> la realidad operativa del negocio.

------------------------------------------------------------------------

## 5. Aspectos Críticos

- LIC puede tener múltiples proveedores.
- LIC puede generar múltiples OC.
- OC no siempre pertenece al mismo período que la LIC.
- Forzar relaciones 1:1 genera distorsión analítica.
- Riesgo de KPIs incorrectos si se simplifica la estructura.

------------------------------------------------------------------------

## 6. Hallazgos Relevantes

- No existe correspondencia estricta LIC ↔ OC.
- El negocio opera bajo lógica más compleja que el modelo inicial.
- La granularidad correcta debe considerar proveedor, producto,
  licitación y orden de compra.
- Se requieren ajustes estructurales en el modelo dimensional.

------------------------------------------------------------------------

## 7. Importancia de Archivos Clave

### 7.1 `01_modelado_vs_negocio.md`

Documento crítico que:

- Explica el conflicto entre modelo técnico y realidad del negocio.
- Marca el punto de inflexión del proyecto.
- Justifica el rediseño estructural.
- Demuestra madurez de ingeniería y comprensión del dominio.

------------------------------------------------------------------------

### 7.2 `README.md`

Define:

- Contexto del análisis
- Objetivos formales
- Organización del build
- Trazabilidad del proceso

Convierte el conjunto de archivos en un entregable estructurado y
defendible.

------------------------------------------------------------------------

## 8. Conclusión

El build `2025-12-15` representa evidencia formal de calidad de datos,
justificación empírica de decisiones de modelado y evolución
arquitectónica del proyecto.

Marca el momento en que el modelo deja de ser solo técnicamente correcto
y pasa a estar alineado con la realidad del negocio.
