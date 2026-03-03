# Hallazgos técnicos — Build 2025-12-15

Este directorio contiene los **hallazgos técnicos y métricas de calidad** generados a partir del análisis de los datasets reales de ChileCompra utilizados en el TFM **ChileCompra Data Platform (UCM)**.

Los artefactos aquí presentes constituyen **evidencia técnica formal** que respalda las decisiones de diseño adoptadas en la **Fase 3 (Modelo Dimensional y Data Warehouse)** y fases posteriores del proyecto.

---

## 1. Origen de los datos analizados

Los hallazgos se generaron a partir de:

- Datos LIC (Licitaciones) — múltiples meses (2024–2025)
- Datos OC (Órdenes de Compra) — múltiples meses (2024–2025)
- Maestro de Organismos Compradores (cuando disponible)

Todos los datos provienen de la capa **01_RAW** y **02_CLEAN** del Data Lake ubicado en:

``` text
${DATA_LAKE_ROOT}/
```

---

## 2. Objetivo de este paquete de hallazgos

Este conjunto de archivos tiene como objetivos:

- Evaluar **calidad, volumen y consistencia** de los datasets LIC, OC y Organismos.
- Identificar **anomalías estructurales** (archivos incompletos, meses atípicos).
- Analizar **relaciones reales entre datasets** (LIC ↔ OC ↔ Organismos).
- Detectar **claves naturales candidatas** y limitaciones de integridad referencial.
- Proveer insumos objetivos para:
  - diseño del modelo dimensional,
  - definición del modelo físico en PostgreSQL,
  - creación de checks de calidad automatizados.

---

## 3. Descripción de los artefactos principales

### 3.1 Profiling y diccionarios

- `ORG_profiles.jsonl`  
- `ORG_dict.md`  

Perfiles y diccionario de campos del maestro de organismos compradores.

### 3.2 Resúmenes de inventario

- `raw_inventory_lic.csv`  
- `raw_inventory_oc.csv`  

Inventario de archivos y métricas básicas (filas, columnas, tamaños) para LIC y OC.

### 3.3 Relaciones entre datasets

- `relationships_metrics.json`  
- `relationships_examples.csv`  

Métricas de intersección y ejemplos reales de relaciones entre campos LIC ↔ OC ↔ Organismos.

**Hallazgo clave:** los códigos de organismo en LIC/OC no presentan match 1:1 con el maestro oficial, lo que impacta directamente el diseño de `dim_organismo`.

### 3.4 Quality gates

- `quality_gates_summary.csv`  

Resumen de reglas de calidad detectadas (duplicados, nulos, volúmenes anómalos) que deben convertirse en validaciones del DW.

### 3.5 Notas de diseño PostgreSQL

- `postgres_design_notes.md`  
- `postgres_recommendations.sql`  

Recomendaciones técnicas para el diseño del modelo físico del DW en PostgreSQL (tipos, staging, índices, buenas prácticas).

### 3.6 Log de construcción

- `readme_build_log.txt`  

Registro del proceso de generación de los hallazgos y parámetros de ejecución.

---

## 4. Uso de estos hallazgos en el TFM

Estos artefactos se utilizan explícitamente en:

- `docs/modelado/rulebook_clean_to_dw.md`  
  → Justificación de dimensiones, claves naturales y reglas CLEAN → DW.
- `sql/quality_checks.sql`  
  → Definición de validaciones automáticas de calidad.
- `db/dw_schema.sql`  
  → Decisiones de tipos de datos y diseño físico.
- Documento final del TFM  
  → Evidencia empírica para justificar decisiones arquitectónicas.

---

## 5. Estado

Este paquete de hallazgos se considera **cerrado y versionado** a fecha **2025-12-15**.  
Cualquier análisis adicional deberá generarse como un nuevo build en un directorio separado.
