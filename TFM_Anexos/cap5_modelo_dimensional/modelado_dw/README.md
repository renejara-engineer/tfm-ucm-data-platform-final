# TFM — Diseño e implementación de un sistema ETL automatizado para la integración y análisis de datos abiertos de contratación pública

**Trabajo Fin de Máster (TFM)**  

## Modelado del Data Warehouse

## 1. Propósito del Directorio

Este directorio documenta la implementación técnica del modelo dimensional; la definición analítica, validación y explotación se documentan en fase_modelado_dw/.

Incluye:

- Diccionario de datos del DW.
- Reglas de transformación desde capa limpia hacia modelo dimensional.
- Definición de grano analítico.
- Estructura de hechos y dimensiones.

---

## 2. Contexto dentro de la evolución del proyecto

El modelado dimensional aquí documentado corresponde a la etapa de consolidación posterior a la fase exploratoria inicial basada en un enfoque tipo Data Lake (RAW–CLEAN–MART).

Durante dicha etapa exploratoria se validó:

- La estructura real de las fuentes.
- La consistencia semántica de campos.
- El comportamiento de volúmenes y granularidad.

La transición hacia una arquitectura gobernada por periodo (INBOX–STG–DW) exigió formalizar explícitamente el modelo analítico, definiendo:

- Grano de hechos.
- Claves sustitutas.
- Relaciones dimensionales.
- Reglas de transformación reproducibles.

Este directorio documenta esa formalización.

---

## 3. Relación con otros módulos

- `metadata/` → Define contrato estructural de las fuentes.
- `fase_modelado_dw/` → Define contratos metodológicos y validación (Gates).
- `db/` → Implementación física del modelo.
- `Estado_oficial_pipeline_dw.md` → Estado consolidado vigente.

---

## 4. Rol dentro de la arquitectura vigente

El modelo dimensional documentado aquí constituye la base analítica oficial del proyecto y actúa como fundamento para:

- Capa semántica.
- Validaciones SQL reproducibles.
- Auditoría DW–BI.
- Explotación en Power BI.

---
