# 📌 TFM — Diseño e implementación de un sistema ETL automatizado para la integración y análisis de datos abiertos de contratación pública

**Trabajo Fin de Máster (TFM)**  

## Arquitectura del Proyecto  

## 1. Propósito del Directorio

El presente directorio consolida la **documentación arquitectónica oficial**
del proyecto.

Su objetivo es:

- Establecer el marco conceptual y técnico del sistema.
- Documentar la evolución arquitectónica del proyecto.
- Diferenciar documentos fundacionales, operativos y consolidados.
- Servir como guía estructural para revisión académica.

Este directorio no contiene código ejecutable, sino la
**definición formal de la arquitectura implementada**.

---

## 2. Evolución Arquitectónica del Diseño

El diseño arquitectónico del proyecto no fue lineal ni definitivo desde su inicio.  
Por el contrario, respondió a un proceso iterativo de exploración, validación y
consolidación técnica, coherente con buenas prácticas de ingeniería de datos aplicada.

### 2.1 Iteración Inicial: Enfoque Data Lake RAW–CLEAN–MART

En una primera etapa, el proyecto adoptó un enfoque clásico tipo *lakehouse*, basado en:

- Organización de archivos en zonas RAW → CLEAN → MART.
- Procesamiento mediante scripts Python.
- Consolidación directa hacia estructuras analíticas simplificadas.
- Persistencia principal en archivos estructurados.

Esta aproximación permitió:

- Comprender la estructura real de las fuentes públicas.
- Detectar inconsistencias semánticas.
- Evaluar volumen, granularidad y comportamiento de los datos.
- Construir primeros artefactos de metadata.

Sin embargo, presentaba limitaciones en términos de:

- Control formal de integridad.
- Idempotencia fuerte por periodo.
- Trazabilidad analítica estructurada.
- Gobernanza explícita de decisiones de carga.

Esta iteración se conserva documentada en `legacy_lakehouse/` como evidencia metodológica.

---

### 2.2 Transición hacia Arquitectura Gobernada por Periodo

Tras el análisis técnico y académico del alcance del proyecto, se adopta una arquitectura
más formal y defendible, basada en:

- Introducción de una zona de entrada controlada (`INBOX`).
- Creación dinámica de tablas STG por periodo.
- Separación explícita STG → DW.
- Implementación de Gate 3 como punto de consolidación analítica.
- Registro formal de estado en `dw.etl_control_cargas`.
- Incorporación de decisiones metodológicas (RUN / NO-OP / EXCEPCION_FUENTE).

Esta transición permitió:

- Asegurar idempotencia por periodo.
- Formalizar el control de calidad estructural y semántico.
- Garantizar reproducibilidad académica.
- Establecer una base sólida para la capa BI.

---

### 2.3 Arquitectura Vigente

La arquitectura actual corresponde al modelo relacional gobernado por periodo, donde:

- El Data Lake actúa como zona de almacenamiento físico de entrada controlada por periodo.
- El Data Warehouse en PostgreSQL constituye la fuente analítica oficial.
- Las decisiones de carga quedan registradas y auditables.
- La capa de explotación analítica se apoya en un modelo dimensional estable.
- El directorio `data/ChileCompraDL/00_INBOX/` actúa como zona de entrada controlada del Data Lake.

La evolución descrita no representa una sustitución tecnológica improvisada,  
sino una maduración progresiva del diseño arquitectónico, basada en evidencia empírica y
criterios de rigor metodológico.

---

## 2.4. Arquitectura de Sistema Completo

El proyecto *ChileCompra Data Platform* se concibe como una arquitectura integrada de
sistema completo, estructurada en capas funcionales claramente diferenciadas y documentadas
en módulos específicos del repositorio.

La arquitectura no se limita al Data Warehouse, sino que incorpora de forma explícita los
componentes de orquestación, explotación analítica y evidencia académica, garantizando
trazabilidad extremo a extremo.

### 2.4.1. Capa de Ingesta Controlada

- Ubicación: `data/ChileCompraDL/00_INBOX/`
- Función: recepción estructurada de archivos por período.
- Característica clave: organización gobernada por mes, evitando acumulación histórica no controlada.
- No constituye almacenamiento analítico, sino zona de entrada controlada.

---

### 2.4.2. Capa de Procesamiento (ETL)

- Ubicación: `etl/`
- Función: transformación desde INBOX hacia tablas STG y posterior carga al Data Warehouse.
- Incluye:
  - validaciones estructurales,
  - control de periodos,
  - reglas de transformación,
  - templates SQL parametrizados.

Esta capa implementa la lógica técnica de consolidación de datos.

---

### 2.4.3. Capa de Persistencia Analítica (Data Warehouse)

- Ubicación: `db/`, `modelado_dw/` y `fase_modelado_dw/`
- Función: almacenamiento estructurado bajo modelo dimensional.
- Incluye:
  - esquema relacional,
  - claves y relaciones,
  - reglas de modelado,
  - vistas semánticas `dw_sem`.

Esta capa constituye la base oficial para cualquier explotación analítica.

---

### 2.4.4. Capa de Orquestación

- Ubicación: `orquestacion/`
- Tecnología: n8n.
- Función: automatización del pipeline por periodo.
- Incluye:
  - ejecución controlada,
  - manejo de condiciones NO-OP,
  - control por tamaño de archivo,
  - separación de entornos DEV y DEMO.

La orquestación no modifica la lógica de negocio, sino que garantiza reproducibilidad operativa.

---

### 2.4.5. Capa de Explotación Analítica (BI)

- Ubicación: `explotacion_analitica/`
- Tecnología: Power BI.
- Fuente exclusiva: vistas del Data Warehouse (`dw_sem`).
- Carácter: descriptivo y documental.

Power BI no transforma datos ni redefine métricas; únicamente visualiza resultados previamente
consolidados en el DW.  
Las reglas metodológicas (segmentación por moneda, carácter no evaluativo, separación de
universos de cruce) se encuentran documentadas en su módulo correspondiente.

---

### 2.4.6. Capa de Evidencia y Auditoría

- Ubicación: `evidencia_academica/`
- Función:
  - validación DW–BI,
  - coherencia numérica,
  - trazabilidad SQL–DAX,
  - respaldo de decisiones metodológicas.

Esta capa garantiza que la plataforma no solo funcione técnicamente, sino que sea
académicamente verificable.

---

## 2.4.7. Integración de Capas

La arquitectura completa puede sintetizarse como:

INBOX → ETL → STG → DW → Orquestación → BI → Evidencia

Cada capa mantiene separación de responsabilidades, evitando solapamientos funcionales
y permitiendo una documentación modular coherente.

---

## 3. Estructura y jerarquía documental

La documentación arquitectónica se organiza en tres niveles:

### Nivel 1 — Fundacional (Marco y alcance)

1. `01_TFM_Scoping_Oficial.md`  
   Define el alcance inicial, modalidad seleccionada y marco institucional del proyecto.

2. `02_architecture_tecnica_ver1.md`  
   Describe la arquitectura técnica operativa del sistema (componentes, ETL, Docker, PostgreSQL, orquestación).

3. `03_architecture_academia_ver1.md`  
   Formaliza académicamente la arquitectura implementada, alineándola con estándares de modelado y reproducibilidad.

---

### Nivel 2 — Modelado y decisiones técnicas

Subdirectorios asociados a la implementación del Data Warehouse:

- `fase_modelado_dw/`  
  Documenta el modelo dimensional, criterios formales de validación y consolidación analítica del DW.

- `modelado_dw/`  
  Contiene diccionarios de datos y reglas formales de transformación.

- `metadata/`  
  Documenta catálogos, esquemas y resúmenes estructurales de datos fuente.

- `documentos_generales/`  
  Contiene el marco de contexto, entorno, hitos y control del proyecto (evolución narrativa, checklist BI predefensa y
  registro de cambios).

---

### Nivel 3 — Estado consolidado

- `Estado_oficial_pipeline_dw.md`  

Constituye el **acta técnica oficial del estado productivo del pipeline y del Data Warehouse**.

Este documento:

- Declara periodos procesados y validados.
- Formaliza decisiones de exclusión de datos.
- Consolida arquitectura efectiva STG → DW.
- Prevalece en caso de discrepancia con documentación histórica.
- Constituye la fuente de verdad oficial respecto del estado productivo del sistema.

---

## 4. Síntesis de evolución

La evolución arquitectónica se describe en detalle en la Sección 2.  
En síntesis, el proyecto transitó desde una etapa exploratoria tipo lakehouse
(evidenciada en `legacy_lakehouse/`) hacia una arquitectura gobernada por periodo
basada en `INBOX–STG–DW`, con estado consolidado declarado en `Estado_oficial_pipeline_dw.md`.

---

## 5. Relación con Otros Directorios del Proyecto

| Directorio                |                   Rol                      |
|---------------------------|--------------------------------------------|
| `db/`                     | Definición física del Data Warehouse       |
| `etl/`                    | Implementación técnica del pipeline        |
| `sql_historial_dw/`       | Registro histórico de transformaciones     |
| `legacy_lakehouse/`       | Iteración arquitectónica descartada        |
| `explotacion_analitica/`  | Evidencia pre-BI y validaciones            |
| `evidencia_academica/`    | Auditoría, trazabilidad y coherencia DW–BI |
| `orquestacion/`           | Automatización del pipeline por periodo    |

Este directorio (`arquitectura/`) actúa como **capa conceptual y documental superior**.

---

## 6. Orden de lectura recomendado (Evaluación académica)

Para revisión estructurada se recomienda el siguiente orden:

1. `01_TFM_Scoping_Oficial.md`
2. `03_architecture_academia_ver1.md`
3. `02_architecture_tecnica_ver1.md`
4. `fase_modelado_dw/`
5. `Estado_oficial_pipeline_dw.md`

Este orden permite comprender:

- El problema.
- La solución conceptual.
- La implementación técnica.
- La consolidación final.

> Nota: El documento técnico 02 puede leerse antes o después del 03 según el perfil del lector: técnico o académico.

---

## 7. Declaración de Estado Arquitectónico

La arquitectura vigente del proyecto se considera:

- Estable.
- Reproducible.
- Auditada.
- Idempotente.
- Documentada.
- Alineada con principios de gobernanza de datos.

No se contemplan rediseños estructurales adicionales dentro del alcance definido para el TFM.

---

## 8. Declaración Final

Este directorio constituye la referencia formal de la arquitectura implementada en el TFM.

Debe interpretarse como el marco conceptual y técnico oficial del sistema, complementando
—pero no sustituyendo— la memoria académica del proyecto.

---

## 9. Declaración de Congelamiento Arquitectónico

A la fecha de cierre del presente Trabajo Fin de Máster, la arquitectura
descrita en este directorio se declara formalmente consolidada para efectos
académicos.

La estructura INBOX–STG–DW, el modelo dimensional implementado, la
orquestación mediante n8n y la capa de explotación analítica en Power BI
constituyen el diseño definitivo dentro del alcance aprobado del TFM.

No se contemplan modificaciones estructurales adicionales que alteren:

- La organización por periodo.
- La separación de responsabilidades entre capas.
- El modelo dimensional vigente.
- Los mecanismos de control e idempotencia.
- La trazabilidad DW–BI formalmente validada.

Cualquier evolución futura deberá entenderse como extensión del proyecto
más allá del alcance académico evaluado, y no como corrección del diseño
consolidado.

Con esta declaración se da por cerrado el módulo arquitectónico del
repositorio.

---
