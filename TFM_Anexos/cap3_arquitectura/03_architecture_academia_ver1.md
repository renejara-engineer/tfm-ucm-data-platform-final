# TFM — Diseño e implementación de un sistema ETL automatizado para la integración y análisis de datos abiertos de contratación pública  

**Universidad Complutense de Madrid (UCM)**  
**Máster de Formación Permanente en DATA SCIENCE, BIG DATA & BUSINESS ANALYTICS**  
**Trabajo Fin de Máster (TFM)**

## Arquitectura del sistema — ChileCompra Data Platform  

## 0. Naturaleza del documento

El presente documento formaliza académicamente la arquitectura implementada en el proyecto.

Su propósito es:

- Justificar las decisiones de modelado.
- Explicar la separación conceptual de capas (STG → DW → SEM).
- Alinear la implementación técnica con estándares de ingeniería de datos.
- Vincular la arquitectura con la narrativa del TFM.

Los detalles operativos específicos (Docker, comandos, scripts) se documentan en:

`02_architecture_tecnica_ver1.md`

## 1. Propósito del documento

Este documento describe la **arquitectura técnica** del proyecto **ChileCompra Data Platform**, desarrollado como Trabajo Fin de Máster bajo la modalidad:

> Construcción de un pipeline reproducible para integración y disponibilización de datos estructurados.

Su objetivo es:

- explicar los componentes principales del sistema,  
- mostrar cómo se relacionan entre sí,  
- documentar el flujo extremo a extremo del dato,  
- y servir como referencia tanto para la memoria del TFM como para cualquier persona que quiera ejecutar o extender la plataforma.

Este documento complementa a:

- `docs/01_TFM_Scoping_Oficial.md` (alcance y objetivos),  
- la memoria escrita del TFM,  
- y el README del repositorio (instrucciones de uso).

---

## 2. Resumen conceptual del sistema

El proyecto implementa una **plataforma de ingeniería de datos** que:

- integra datos estructurados de compras públicas de Chile (Licitaciones LP, Órdenes de Compra OC, Catálogo de organismos compradores),  
- organiza los datos en un **Data Lake** con zonas RAW, CLEAN y MART,  
- carga la información transformada en un **Data Warehouse PostgreSQL**,  
- permite orquestar el pipeline con **n8n**,  
- y habilita consumo analítico mediante SQL y herramientas de BI (Power BI / Streamlit, etc.).

El foco está en la **reproducibilidad, modularidad y trazabilidad**, no en modelos predictivos avanzados.

---

## 3. Arquitectura global (vista de alto nivel)

```mermaid
flowchart LR

    subgraph Sources[Fuentes ChileCompra]
        A(Licitaciones LP) -->|CSV/XLSX| RAW_LP
        B(Órdenes de Compra OC) -->|CSV/XLSX| RAW_OC
        C(Catálogo Organismos) --> RAW_CAT
    end

    subgraph DATALAKE[Data Lake (Disco externo)]
        RAW_LP[RAW LP] --> CLEAN_LP[CLEAN LP]
        RAW_OC[RAW OC] --> CLEAN_OC[CLEAN OC]
        RAW_CAT[RAW Catálogo] --> CLEAN_CAT[CLEAN Catálogo]
    end

    subgraph DW[PostgreSQL - Data Warehouse]
        CLEAN_LP --> FACT_LP[FACT_LICITACIONES]
        CLEAN_OC --> FACT_OC[FACT_ORDENES_COMPRA]
        CLEAN_CAT --> DIM_ORG[DIM_ORGANISMOS]
    end

    subgraph ORCH[n8n - Orquestación]
        ORCH[Workflows n8n] -->|Trigger / Schedule| ETL[Contenedor ETL Python]
    end

    DW --> BI[BI / SQL / Dashboards]

```

## Estado actual del proyecto (checkpoint académico)

✔ Arquitectura técnica implementada y operativa.  
✔ Data Lake funcional con estructura RAW → CLEAN → Metadata.  
✔ Servicio ETL conectado correctamente a PostgreSQL.  
✔ Análisis completo de columnas, tipos, catálogos, llaves y granularidades.  

➡ Próximo paso académico: **Modelado físico del Data Warehouse (DDL + constraints + particionado).**

---

## 🧩 Conjunto de Metadata Oficial Integrado en el Proceso

Durante la Fase 2 del proyecto se consolidó un grupo de artefactos de metadata esenciales para la definición del modelo dimensional y las reglas de transformación:

- Diccionario esquemático de Licitaciones (LP)
- Diccionario esquemático de Órdenes de Compra (OC)
- Catálogo maestro de organismos públicos compradores

Estos artefactos permiten abstraer las decisiones arquitectónicas sin requerir acceso a los datos originales (principio de *data lineage reproducible*). Además, simplifican el modelado académico al establecer:

- dominios conceptuales claros,  
- llaves naturales verificables,  
- catálogos auxiliares normalizados,  
- y una ruta de transformación consistente (RAW → CLEAN → DW).

Los archivos están almacenados en:

/docs/metadata/

Su utilización permite justificar y replicar:

- decisiones de tipificación,
- reglas de normalización,
- diseño de tablas DIM y FACT,
- y estrategias de orquestación.

---

## Fase 3: Evolución de la arquitectura del proyecto

Durante las primeras fases del TFM se establecieron los cimientos técnicos necesarios para una plataforma de datos reproducible.

La Fase 3 marca el cierre de la etapa fundacional, donde el foco estuvo en:

- Comprensión estructural de las fuentes
- Organización del Data Lake
- Preparación del entorno para procesos ETL posteriores

Esta decisión responde a buenas prácticas de ingeniería de datos, donde la analítica se construye sobre una base de datos confiable y estructurada.

---

### Fase 4: Automatización y Orquestación

La Fase 4 introduce una capa de automatización que permite coordinar procesos ETL sin intervención manual, asegurando repetibilidad, trazabilidad y control del sistema.

Se opta por n8n en modalidad local para cumplir restricciones académicas:

- Cero dependencia cloud
- Costo nulo
- Control total del entorno

La arquitectura refuerza principios de ingeniería reproducible y separación de responsabilidades.

---

## Decisiones metodológicas y control de alcance

Durante el desarrollo del proyecto se adoptó deliberadamente una estrategia
de **alcance controlado**, separando claramente:

- la **habilitación analítica del modelo de datos**, y
- la **automatización continua del pipeline de ingesta**.

### Justificación académica

La decisión de no implementar automatización completa en esta etapa responde a:

- la necesidad de **validar analíticamente** el modelo propuesto,
- evitar introducir complejidad operativa innecesaria,
- asegurar la **validez de los KPIs y conclusiones** presentadas en la memoria.

El uso de un **periodo piloto controlado** permite demostrar de forma rigurosa
la corrección del diseño del Data Warehouse y de la capa analítica,
sin que la automatización o el volumen de datos distorsionen los resultados.

### Proyección futura

La arquitectura propuesta deja explícitamente habilitada la incorporación
de automatización por eventos o por calendario, la cual podrá ser abordada
como una extensión futura de la plataforma, sin alterar las conclusiones
ni el alcance del Trabajo Fin de Máster.

## Caso de estudio: Inconsistencia monetaria en datos públicos

Durante la implementación del Data Warehouse analítico se identificó una inconsistencia crítica en los montos de órdenes de compra.

### Contexto

- Fuente: ChileCompra
- Campo: `montototaloc`
- Síntoma: montos excesivos no plausibles

### Diagnóstico

Se descartó:

- Error de joins
- Error de llaves
- Error de modelado dimensional

La causa fue una diferencia semántica:

- Uso de coma como separador decimal en datos públicos

### Resolución

- Rediseño del proceso ETL
- Regla explícita de interpretación numérica
- Validación estadística posterior

### Aprendizaje académico

Este caso demuestra la importancia de:

- Auditoría semántica de fuentes
- Validación exploratoria post-carga
- Documentación de decisiones técnicas

El problema y su solución fortalecen la validez del modelo final.

---

## Tratamiento de Calidad de Datos en Fuentes Públicas

En proyectos con datos administrativos reales (ej. ChileCompra),
los errores semánticos de formato son parte inherente de la fuente.

En este TFM:

- No se eliminan registros
- No se “corrige” manualmente
- Se documenta y formaliza una regla reproducible

Esto cumple con:

- Principio de trazabilidad
- Reproducibilidad
- Separación entre fuente, staging y DW

La corrección se realiza en el DW,
justificada como capa semántica final,
antes del consumo analítico.

---

## Automatización del Pipeline Mensual

La plataforma implementa un pipeline automático mensual parametrizado por periodo (YYYY-MM), alineado con principios de ingeniería de datos reproducible.

### Justificación académica del pipeline mensual

- Separación clara entre:
  - Ingesta
  - Transformación
  - Persistencia analítica
- Control explícito del estado de cada carga
- Validaciones semánticas integradas al flujo

### Ventajas metodológicas

- Permite crecimiento temporal sin modificar código
- Facilita auditoría posterior
- Garantiza consistencia inter-periodos

Este enfoque habilita una transición limpia hacia la fase analítica (KPIs), sin comprometer integridad del DW.

---

## Decisión metodológica en Fase 5: Control de carga mediante NO-OP

Durante la Fase 5 del proyecto se incorporó un criterio metodológico explícito
para el control de cargas al Data Warehouse, basado en la evaluación previa de
la calidad y completitud de los datos por período.

### Justificación académica del uso de NO-OP en Fase 5

En contextos reales de plataformas de datos públicas, la existencia de datos
no garantiza su aptitud analítica. Automatizar la carga sin evaluación previa
puede introducir sesgos, inconsistencias temporales y conclusiones erróneas
en la capa de Business Intelligence.

Por este motivo, se adopta el concepto de **NO-OP (No Operation)** como una
decisión válida, equivalente en rigor metodológico a la ejecución de ETL.

### Implicancias

- El Data Warehouse solo contiene períodos analíticamente válidos.
- Los períodos excluidos quedan documentados y trazables.
- La capa BI se construye sobre un conjunto de datos coherente y defendible.
- Se evita la corrección artificial de datos de origen.

Esta decisión refuerza el rigor académico del proyecto y alinea la solución
con buenas prácticas profesionales de ingeniería de datos.

---

### Decisiones de no ejecución (NO-OP) como principio metodológico

En contextos reales de datos públicos, la ausencia de ejecución del ETL
no implica un fallo del pipeline, sino una **decisión consciente** orientada a
preservar la calidad analítica.

En este TFM, determinados periodos presentan:

- estructuras incompletas,
- volúmenes anómalos,
- o esquemas no comparables.

Forzar su carga habría introducido sesgos analíticos,
por lo que se adopta explícitamente la estrategia NO-OP,
registrada y auditable.

### Decisiones NO-OP como principio metodológico

En el contexto de datos públicos reales, la ausencia de ejecución de un proceso
no constituye necesariamente un error técnico, sino que puede representar
una decisión metodológicamente correcta.

En este proyecto, se introduce el concepto **NO-OP (No Operation)** como una
decisión explícita del pipeline que indica que, para un periodo determinado,
los datos disponibles son válidos desde el punto de vista de origen, pero no
cumplen las condiciones mínimas para una carga analítica confiable en el
Data Warehouse.

La no ejecución del ETL en estos casos es una acción deliberada, auditable y
registrada, orientada a preservar la integridad analítica del modelo de datos
y evitar la introducción de sesgos derivados de información incompleta,
anómala o no comparable.

---

### Justificación metodológica del enfoque batch mensual

Desde una perspectiva académica y metodológica, el TFM adopta un enfoque de
procesamiento batch mensual para el pipeline ETL, en lugar de un modelo de
procesamiento continuo o en tiempo real.

Esta decisión se fundamenta en:

- la naturaleza administrativa y pública de los datos ChileCompra,
- la periodicidad real de actualización de las fuentes,
- la necesidad de mantener control estricto de calidad y coherencia temporal,
- y la prioridad de garantizar reproducibilidad y auditabilidad del pipeline.

El objetivo del TFM no es evaluar la disponibilidad operativa de un servicio ETL,
sino demostrar la correcta ingeniería del flujo de datos desde la fuente hasta
la capa analítica, bajo criterios de trazabilidad, idempotencia y validación
sistemática.

El uso de un enfoque batch permite además documentar explícitamente decisiones
técnicas como períodos NO-OP o excepciones de fuente, las cuales forman parte
natural del tratamiento de datos reales en contextos institucionales.

---

Desde un punto de vista académico, el proceso ETL se concibe como un pipeline de ejecución batch,
orientado a la carga y validación periódica de datos, y no como un servicio de negocio de ejecución continua.

No obstante, el uso de contenedores Docker permite encapsular el entorno de ejecución y exponer
mecanismos técnicos de verificación (por ejemplo, endpoints de salud) cuyo propósito es garantizar
reproducibilidad, auditabilidad y correcta configuración del entorno, sin alterar el carácter batch
del proceso ni condicionar las fases analíticas posteriores.

---
