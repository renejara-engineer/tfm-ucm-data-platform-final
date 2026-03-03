# 📦 Módulo de Metadatos

## ChileCompra Data Platform --- TFM

------------------------------------------------------------------------

## 1. Descripción General

El directorio `metadata/` constituye el módulo formal de metadatos estructurales
del proyecto *ChileCompra Data Platform*.

Su propósito es consolidar, versionar y documentar la definición estructural
 normalizada de las fuentes de datos consolidadas, utilizadas como base para la 
 implementación del modelo dimensional en el Data Warehouse, garantizando:

- Consistencia estructural
- Trazabilidad técnica
- Gobernanza de datos
- Reproducibilidad del modelo

Este módulo representa la capa de contrato estructural (*data contract*) entre
 las fuentes procesadas y el modelo dimensional implementado en el Data Warehouse,
  estableciendo de forma explícita las definiciones oficiales de esquemas, columnas
   y catálogos.

Su formalización surge tras la transición desde la etapa exploratoria inicial basada
 en la organización RAW–CLEAN–MART hacia una arquitectura gobernada por periodo
 (INBOX–STG–DW), donde se identificó la necesidad de explicitar y versionar los
 esquemas estructurales como parte integral de la gobernanza del modelo.

Este módulo no constituye una capa operativa del pipeline, sino una referencia 
estructural documental que sustenta y delimita técnicamente el modelado dimensional.

------------------------------------------------------------------------

## 2. Estructura del Directorio

``` bash
metada/
├── README_metada.md
└── Archivos/
    ├── summary_master_v2.md
    ├── schema_lic_clean_any.csv
    ├── schema_oc_clean_any.csv
    └── catalogo_organismos_2025-11.csv
```

Este módulo se vincula directamente con:

- `modelado_dw/` (implementación del modelo dimensional)
- `fase_modelado_dw/` (validación analítica y gobierno del modelo)

------------------------------------------------------------------------

## 3. Propósito del Módulo

1. Documentar la estructura limpia y estandarizada de los datasets.
2. Formalizar los esquemas utilizados en el modelado dimensional.
3. Servir como referencia técnica para procesos de validación y carga.
4. Establecer un contrato estructural estable entre etapas del
   pipeline.
5. Facilitar auditoría técnica y revisión académica.
6. Mitigar riesgos ante cambios estructurales en fuentes originales.

------------------------------------------------------------------------

## 4. Contenido del Subdirectorio `Archivos/`

### 📄 summary_master_v2.md

Documento maestro que explica decisiones de normalización, criterios de
limpieza y estructura final.

### 📊 schema_lic_clean_any.csv

Definición estructural consolidada del dataset de Licitaciones (LIC).

### 📊 schema_oc_clean_any.csv

Definición estructural consolidada del dataset de Órdenes de Compra
(OC).

### 🏛 catalogo_organismos_2025-11.csv

Catálogo consolidado de organismos compradores utilizado como dimensión
institucional.

------------------------------------------------------------------------

## 5. Resultados Obtenidos

- Estandarización formal de estructuras LIC y OC.
- Eliminación de ambigüedad estructural.
- Consolidación de dimensión institucional estable.
- Base sólida para modelado dimensional.
- Reducción del riesgo de inconsistencias entre entornos.

------------------------------------------------------------------------

## 6. Evidencias Técnicas

- Documentación explícita de estructura oficial.
- Reproducibilidad del modelo estructural.
- Definición clara de columnas válidas para explotación.
- Artefactos auditables (.csv y .md).

------------------------------------------------------------------------

## 7. Aspectos Críticos

- Diferencias entre estructura cruda y analítica.
- Dependencia del catálogo institucional.
- Riesgo ante cambios en fuentes externas.
- Necesidad de versionado formal.

------------------------------------------------------------------------

## 8. Funcionalidad en el Pipeline

Referencia estructural utilizada para la validación y
construcción de tablas staging.

------------------------------------------------------------------------

## 9. Importancia Estratégica

El módulo `metada/`:

- Centraliza el conocimiento estructural.
- Formaliza la definición oficial de esquemas.
- Reduce riesgos de divergencia.
- Garantiza trazabilidad.
- Actúa como soporte documental del TFM.

------------------------------------------------------------------------

## 10. Gobernanza y Versionado

Se recomienda:

- Versionar junto al código ETL.
- Registrar fecha de actualización en catálogos.
- Evaluar impacto antes de modificar esquemas.

------------------------------------------------------------------------

## 11. Conclusión

Este módulo materializa el principio de gobernanza estructural adoptado
en el proyecto, asegurando que toda transformación posterior se base en
definiciones explícitas, versionadas y auditables.

El módulo `metada/` constituye una pieza fundamental de gobernanza,
trazabilidad y formalización estructural del proyecto, asegurando
consistencia, reproducibilidad y claridad arquitectónica.
