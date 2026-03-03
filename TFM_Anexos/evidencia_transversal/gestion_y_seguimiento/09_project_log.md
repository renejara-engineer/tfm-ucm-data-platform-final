
# Project Log — TFM ChileCompra Data Platform

> Registro cronológico **histórico** de decisiones, ejecuciones,
> validaciones y cierres del proyecto.
>
> Este archivo **NO constituye un backlog activo** ni un plan de trabajo.
> Se conserva como **evidencia metodológica y de trazabilidad académica**.

---

## Estado del documento (definición general)

- Rol: Registro histórico del proyecto
- Vigencia operativa: No activa
- Fases registradas: Fase 1 a Fase 5 (cerradas)
- Fuente de verdad del estado actual:
  - `docs/fase5/08_estado_actual_fase5.md`

Este documento **no autoriza reprocesamientos**, ni redefine estados
ya cerrados.

---

### 2025-12-06 — Sesión de consolidación metodológica (histórica)

**Fases involucradas en ese momento:**  

- Fase 1 (cerrada)  
- Fase 2 (en curso en esa fecha)  
- Fase 3 (en curso en esa fecha)

**Decisiones registradas (histórico):**

- Definición de estructura oficial de fases
- Adopción de metodología documental basada en:
  - documento maestro de fases,
  - project log como registro histórico,
  - prompts de continuidad estandarizados

**Estado técnico verificado en ese momento:**

- Stack Docker funcional
- Repositorio sincronizado
- Pipeline con datos disponibles solo para `2024-09`
- Descargas manuales existentes hasta `2025-11`
- API ChileCompra sin credenciales (dependencia externa)

> Nota: los “pendientes” registrados en esta entrada corresponden
> a estado histórico y **no representan tareas actuales**.

---

### 2025-12-08 — Cierre Fase 2 (Arquitectura + Análisis Semántico)

- Análisis de LIC (~3.65M registros) y OC (~11.88M registros) completado.
- Identificados catálogos clave, granularidades, validaciones semánticas y llaves naturales.
- Confirmado acceso al Data Lake desde el contenedor ETL (`/data_lake`).
- Generados diccionarios automáticos (schema_lic_clean_any.csv, schema_oc_clean_any.csv).
- Validación completa de variables de entorno y montaje Docker.
- Arquitectura técnica marcada como estable.
- Proyecto listo para transición a fase de Modelado del DW (DDL + índices + constraints).

**Estado:** Fase 2 **CERRADA**

---

### 2025-12-08 — Registro de metadata estructural (Fase 2)

Se consolidan artefactos de metadata estructural y se habilita el inicio
de la Fase 3 (modelado DW).

- Creación de la ruta `docs/metadata/`.
- Incorporación de los artefactos:
  - `schema_lic_clean_any.csv`
  - `schema_oc_clean_any.csv`
  - `catalogo_organismos_2025-10-17.csv`
- Documentación de dichas referencias en:
  - `02_architecture_tecnica_ver1.md`
  - `03_architecture_academia_ver1.md`

**Estado:** Fase 2 **CERRADA**

---

### 📅 2025-12-10 — Creación de rulebook CLEAN → DW (Fase 3)

**Acción:**
Se crea el archivo:

`docs/modelado/rulebook_clean_to_dw.md`

que recoge la versión 1 del **Rulebook de Transformación CLEAN → DW**. Este documento:

- define el alcance del DW v1 (fuentes: LIC/OC en 02_CLEAN + Organismos compradores),
- fija la granularidad de las tablas de hechos `fact_licitaciones` y `fact_ordenes_compra`,
- establece las convenciones de claves técnicas vs. claves naturales,
- documenta las rutas físicas reales del Data Lake,
- deja fuera de alcance, explícitamente, los datasets OCDS para el DW v1.

**Motivo:**
Dar soporte formal al diseño del **modelo dimensional** y al **modelo físico en PostgreSQL**, utilizando como fuente de verdad la metadata consolidada en `docs/metada/summary_master_v2.md` y los esquemas de CLEAN (`schema_lic_clean_any.csv` y `schema_oc_clean_any.csv`).

**Impacto:**
Activa oficialmente la Fase 3 de modelado DW sobre una base documentada, permitiendo derivar:

- el diagrama dimensional (`modelo_dimensional_v1.png`),
- el DDL del DW (`db/dw_schema.sql`),
- y los checks de calidad SQL (`sql/quality_checks.sql`).

---

### 📅 2025-12-15 — Integración de hallazgos empíricos en el rulebook (Fase 3)

**Acción:**
Se documentan en `docs/modelado/rulebook_clean_to_dw.md` las tablas de hechos:

- `dw.fact_licitaciones`
- `dw.fact_ordenes_compra`

incluyendo granularidad, claves naturales (`*_bk`), FKs hacia DIMs, medidas, campos de trazabilidad y reglas de carga desde 02_CLEAN.

**Impacto:**
Queda fijada la granularidad del DW v1, habilitando el siguiente paso de Fase 3:

- mapeo CLEAN → DW (columna a columna),
- y generación del DDL físico (`db/dw_schema.sql`).

### 📅 2025-12-16 — Creación del esquema DW y DDL físico (Fase 3)

**Acción:**

- Se define y ejecuta el DDL físico del Data Warehouse v1 en PostgreSQL.
- Se crea el esquema `dw` con 4 dimensiones y 2 tablas de hechos.

**Artefactos:**

- `db/dw_schema.sql`

**Evidencia:**

- Ejecución exitosa vía `psql -f`.
- Comando `\dt dw.*` retorna:
  - `dim_fecha`
  - `dim_organismo`
  - `dim_proveedor`
  - `dim_producto_onu`
  - `fact_licitaciones`
  - `fact_ordenes_compra`.

### 📅 2025-12-16 — Script reproducible de inicialización del DW (Fase 3)

**Acción:**

- Se crea un script shell para inicializar el DW de forma reproducible y orquestable.

**Artefactos:**

- `scripts/db_init_dw.sh`

**Detalle:**

- Verifica servicio PostgreSQL activo.
- Copia `dw_schema.sql` al contenedor.
- Ejecuta el DDL.
- Verifica la existencia de las 6 tablas del esquema `dw`.

**Evidencia:**

- Ejecución exitosa del script sin errores críticos.

### 📅 2025-12-16 — Quality checks del DW v1 (Fase 3)

**Acción:**

- Se implementan y ejecutan validaciones de calidad e integridad sobre el esquema `dw`.

**Artefactos:**

- `sql/quality_checks.sql`

**Validaciones incluidas:**

- Existencia de tablas DW.
- Duplicados en dimensiones (claves naturales).
- Duplicados en hechos por BK + periodo.
- Sanity checks de montos y periodos.
- Integridad referencial (detección de huérfanos).

**Evidencia:**

- Ejecución completa vía `psql -f` sin errores.
- Todos los checks retornan resultados válidos (0 duplicados, 0 huérfanos).

### 📅 2025-12-16 — Integración de hallazgos y exclusión de columnas CLEAN (Fase 3)

**Acción:**

- Se documenta explícitamente la exclusión justificada de columnas CLEAN no incorporadas al DW v1.

**Artefactos:**

- `docs/modelado/rulebook_clean_to_dw.md`
- Referencias a:
  - `schema_lic_clean_any.csv`
  - `schema_oc_clean_any.csv`
  - `summary_master_v2.md`

**Detalle:**

- Se explica que LIC (>100 columnas) y OC (~75 columnas) fueron analizadas,
  pero solo un subconjunto se modela en el DW por criterios analíticos.

**Resultado:**

- Trazabilidad completa CLEAN → DW sin huecos conceptuales.

### 📅 2025-12-16 — Diccionario de datos del DW v1 (Fase 3)

**Acción:**

- Se crea el diccionario de datos final del Data Warehouse v1,
  alineado con el modelo físico implementado en PostgreSQL.

**Artefactos:**

- `docs/modelado/data_dictionary_dw.md`

**Contenido:**

- Convenciones generales.
- Definición completa de dimensiones.
- Definición completa de tablas de hechos.
- Notas de modelado y alcance del DW v1.

**Resultado:**

- Documento final para revisión académica y técnica.

### 📅 2025-12-16 — Cierre Fase 3: Modelo Dimensional y DW v1

**Resultado:**

- Rulebook CLEAN → DW completo y actualizado.
- Modelo dimensional definido y validado.
- DW v1 creado en PostgreSQL (schema `dw`).
- Script reproducible de inicialización disponible.
- Quality checks ejecutables y validados.
- Diccionario de datos final documentado.

**Estado:** Fase 3 **CERRADA técnica y metodológicamente**

Se constata que varias actividades inicialmente planteadas como fases independientes se integrarán en bloques técnicos consolidados a partir de la Fase 4.

### 📅 2025-12-18 — Cierre Fase 4

- Se despliega n8n local en Docker
- Se valida persistencia y seguridad
- Se ejecutan workflows reales
- Se generan evidencias técnicas auditables
- Se implementa estrategia de backup
- La Fase 4 queda cerrada técnica y funcionalmente

**Estado:** Fase 4 **CERRADA**

---

### 2025-12-19 — Decisión sobre automatización INBOX (histórico)

Se define conceptualmente automatización vía INBOX.
Se decide **NO implementar** en ese momento por control de alcance.

> Nota: esta decisión fue posteriormente superada
> por la implementación del pipeline batch mensual validado.

---

## 🧾 ACTA DE HALLAZGO — GATE 3  

**Implementación DW Analítico (Periodo Piloto 2024-09)**  
Fecha: 2026-01-15  
Fase: Fase 5 — Analítica  
Gate: Gate 3 — Implementación DW Analítico  
Origen: Ejecución técnica y validación del Data Warehouse  

### 1. Contexto (Evidencias Pre-BI)

Durante la ejecución del Gate 3 de la Fase 5 del TFM *ChileCompra Data Platform*, se inició la implementación del Data Warehouse analítico para el periodo piloto **2024-09**, conforme al alcance definido y congelado en la planificación de la Fase 5.

El objetivo del Gate 3 es validar la correcta transición desde la capa **CLEAN → DW**, asegurando coherencia estructural, integridad referencial y trazabilidad analítica previa a cualquier desarrollo BI.

---

### 2. Estado verificado al momento del hallazgo

A partir de la evidencia técnica obtenida (contenedores Docker activos, esquema `dw` creado, tablas staging pobladas y Data Lake CLEAN disponible), se verificó el siguiente estado:

- `dw.dim_fecha`: **EJECUTADA**  
  - Periodo cargado correctamente (2024-09).
  - Integridad temporal validada.

- `dw.dim_organismo`: **EJECUTADA**  
  - Cargada desde `public.stg_lic_2024_09`.
  - Cardinalidad consistente con staging (846 organismos).

- `dw.dim_producto_onu`: **EJECUTADA**  
  - Cargada desde `public.stg_oc_2024_09`.
  - Cardinalidad consistente (9.744 productos ONU).

- `dw.dim_proveedor`: **BLOQUEADA**  
  - Reglas de diseño definidas.
  - Error detectado durante la carga por duplicidades lógicas en el conjunto fuente, que generaron conflictos en la cláusula `ON CONFLICT DO UPDATE`.
  - No se completó la carga final.

- Hechos (`dw.fact_licitaciones`, `dw.fact_ordenes_compra`): **NO EJECUTADOS**  
  - Ejecución correctamente detenida por dependencia de dimensiones incompletas.

---

### 3. Hallazgo principal

Se identifica como **hallazgo técnico central** que la dimensión **`dim_proveedor`**, aun estando correctamente modelada a nivel estructural, **requiere un tratamiento explícito de deduplicación y agregación previa** sobre el staging (`stg_oc_2024_09`) para garantizar unicidad por `codigo_proveedor`.

El problema **no corresponde a un error de arquitectura**, sino a una **condición real de los datos fuente**, consistente con la naturaleza operacional del dominio ChileCompra.

---

### 4. Impacto del hallazgo

- **Impacto en alcance**: ❌ Ninguno  
- **Impacto en diseño DW**: ❌ Ninguno  
- **Impacto en KPIs / BI**: ❌ Ninguno  
- **Impacto en planificación**: ⚠️ Menor (ajuste técnico puntual)

El hallazgo **no invalida** el enfoque metodológico, ni requiere rediseño de fases cerradas (Fases 1–4), ni modificación del modelo analítico aprobado.

---

### 5. Decisión adoptada

Se **congela el estado actual del Gate 3** y se establece como **única acción técnica autorizada**:

> 👉 Definir, corregir y ejecutar la carga de `dw.dim_proveedor` aplicando una estrategia de agregación determinística que garantice unicidad por proveedor, conforme a las reglas del Gate 3.

No se autoriza la ejecución de tablas de hechos ni el avance a Gate 4 hasta resolver este punto.

---

### 6. Estado del Gate 3 tras el hallazgo

- Gate 3: **ABIERTO (controlado)**  
- Riesgo académico: **BAJO**  
- Riesgo técnico: **CONTROLADO**  
- Trazabilidad CLEAN → DW: **PRESERVADA**

---

### 7. Registro formal

Este acta deja constancia del hallazgo, su análisis y la decisión adoptada, y pasa a formar parte del **registro oficial del proyecto** para fines de trazabilidad académica y evaluación final del TFM.

---

### 📅 2026-01-15 — Gate 3: Carga dim_proveedor (piloto 2024-09)

Estado del bloque: EJECUTADO + VALIDADO  
Fuente: public.stg_oc_2024_09  
BK: codigo_proveedor (codigoproveedor)  
Regla deduplicación: 1 fila por BK (GROUP BY) + MAX(NULLIF())  
Evidencia: sql/gate3_dim_proveedor.sql ejecutado vía docker compose exec psql < file  

Resultados:

- INSERT = 27206
- dw.dim_proveedor count = 27206
- stg_distinct vs dim_count = 27206 vs 27206
- Duplicados por BK = 0

Siguiente paso autorizado: iniciar carga de hechos (dw.fact_ordenes_compra y dw.fact_licitaciones) + validación analítica.

---

### 📅 2026-01-15 — Gate 3: Validación analítica Niveles 4–5 (piloto 2024-09)

Estado del bloque: VALIDADO (Nivel 4 OK) + VALIDADO (Nivel 5 con observación)  
Periodo: 2024-09

Precondición (Nivel 1):

- LIC = 147755 filas (2024-09)
- OC  = 324419 filas (2024-09)

Nivel 4 — Coherencia analítica:

- Negativos (OC monto_total / LIC monto_estimado / LIC monto_adjudicado / cantidades / oferentes): 0
- Fechas fuera de 2024-09:
  - OC fecha_creacion: 0
  - LIC fecha_publicacion: 0
- Nulos en montos:
  - OC monto_total NULL: 0
  - LIC monto_estimado NULL: 430 (~0.29%)

Nivel 5 — Coherencia de negocio LIC ↔ OC (relación analítica, no 1:1):

- En staging OC:
  - oc_total = 396516
  - oc_con_lic = 147551 (37.21%)
  - oc_sin_lic = 248965
  - lic_distintas_en_oc = 27583
- Totales monetarios (sin exigir cuadratura):
  - sum(LIC monto_adjudicado) = 4392264989332.00
  - sum(OC monto_total) = 749843658573574668.00

Observación crítica abierta (previo a Gate 4):

- Monto OC presenta magnitud desproporcionada vs LIC. Se requiere revisar mapeo/parseo del campo `monto_total` en OC antes de construir BI.

Dictamen auditor:

- Gate 3 cerrado como DW Analítico para periodo 2024-09.
- Gate 4 (Power BI) bloqueado hasta resolver/explicar observación monetaria OC.

---

### ✅ 2026-01-15 — CIERRE FORMAL GATE 3 (DW Analítico) — Piloto 2024-09

Estado: CERRADO (aprobado)  
Periodo: 2024-09  
Alcance: Dimensiones + Hechos + Validación analítica previa a BI

Dimensiones (cargadas y validadas):

- dim_fecha (2024-09)
- dim_organismo = 846
- dim_producto_onu = 9744
- dim_proveedor = 27206 (BK único, 0 duplicados)

Hechos (cargados y validados, periodo 2024-09):

- fact_ordenes_compra = 324419
- fact_licitaciones = 147755

Validaciones Gate 3:

- Unicidad BK+periodo: 0 duplicados (OC y LIC)
- Integridad referencial (FK NULL): 0 (OC y LIC)
- Negativos (montos/cantidades/oferentes): 0
- Fechas fuera del periodo: 0
- LIC monto_estimado NULL: 430 (~0.29%) → documentado como calidad de fuente

Hallazgo y corrección crítica (monetario OC):

- Se detectó inflación por parseo incorrecto de coma decimal en `montototaloc`.
- Corrección aplicSada con loader OC v2 (coma→punto bajo regla determinística).
- Post-fix OC:
  - oc_rows = 324419
  - p50=968660; p90=6988632; p99≈50066363.54; p999≈223880721.4; max≈15875806214.94
  - sum CLP = 1420499591336.64 con n_clp_dw=320644
- Dictamen: montos OC consistentes para explotación analítica.

Nota metodológica (Gate 4):

- OC es multimoneda (CLP/CLF/USD/UTM/EUR). En BI se debe filtrar por moneda (ej. CLP) o segmentar por moneda; no se suman monedas distintas.

Autorización:

- Gate 4 (Power BI) habilitado, condicionado a respetar reglas de modelo semántico y moneda.

---

### 📌 Hallazgo metodológico relevante (Gate 3)

Durante la validación analítica del hecho `fact_ordenes_compra` se detectó una **inconsistencia monetaria severa**:

- Percentiles OC mostraban valores irreales (>10^14)
- El origen fue trazado a la fuente ChileCompra (`stg_oc_2024_09`)
- Campo afectado: `montototaloc`
- Causa raíz: coma usada como separador decimal

Se descartó error de modelo, joins o llaves.

#### Acción correctiva

- Rediseño del loader OC
- Implementación de regla determinística de parseo monetario
- Reejecución completa del hecho OC (script v2)

#### Resultado

- Distribución monetaria consistente
- No negativos
- Integridad referencial intacta
- Gate 3 aprobado sin reservas

Este hallazgo se incorpora como **caso de estudio metodológico** en la memoria TFM.

---

## Cierre Gate 3 — Auditoría Técnica

Incidencia crítica:

- Inflado monetario por parsing incorrecto

Diagnóstico:

- Confirmado en staging
- Confirmado por percentiles
- Confirmado por ejemplos reales

Resolución:

- Reescritura completa loader OC
- Validación post-fix completa

Decisión:

- Gate 3 aprobado
- Gate 4 habilitable bajo condiciones semánticas

Firmado:
Arquitecto de Datos / Auditor DW
Fecha: 2026-01-15

---

2026-01-15 – Cierre definitivo Fase 4

- Carga DW validada para periodo 2024-09
- Corrección semántica de montos OC (coma decimal)
- FACT OC: 324.419 registros
- FACT LIC: 147.755 registros
- Validaciones post-carga OK

---

## 2026-01-15 — CIERRE GATE 3: DW ANALÍTICO

- Dimensiones cargadas:
  - dw.dim_fecha (septiembre 2024 completo, 30 días)
  - dw.dim_organismo
  - dw.dim_proveedor
  - dw.dim_producto_onu

- Hechos cargados:
  - dw.fact_licitaciones: 147.755 filas (periodo 2024-09)
  - dw.fact_ordenes_compra: 324.419 filas (periodo 2024-09)

- Validaciones ejecutadas:
  - Unicidad BK + periodo: OK (sin duplicados)
  - Integridad referencial:
    - LIC: NULL en fecha_cierre_sk documentados como comportamiento esperado
    - OC: NULL en fecha_aceptacion_sk documentados como comportamiento esperado
  - Coherencia monetaria OC:
    - Montos negativos: 0
    - Montos nulos: 2.213 (según fuente)

- Evidencia:
  - SELECT COUNT(*)
  - Validaciones SQL ejecutadas en consola Postgres

Estado: ✅ Gate 3 cerrado técnica y metodológicamente

---

## 2026-01-16 — CONTROL DE CARGAS (IDEMPOTENCIA)

- Tabla creada: dw.etl_control_cargas (PK: entidad + periodo)
- Limpieza de prueba: eliminado registro LIC/2024-10 (no corresponde a periodo cargado)
- Registro oficial piloto:
  - LIC 2024-09: OK | STG=178091 | DW=147755 | archivo=LIC_2024-09.csv
  - OC  2024-09: OK | STG=396516 | DW=324419 | archivo=OC_2024-09.csv

Evidencia: SELECT sobre dw.etl_control_cargas (2 filas).

---

## 2026-01-16 — CORRECCIÓN SEMÁNTICA OC (2024-10) — POST FIX MONETARIO

Motivo:

- Se detectan montos inflados y valores sentinel (999...) en OC 2024-10 al usar script v1.

Acción correctiva:

- Se aplica el script v2 (parseo determinístico de `montototaloc` con coma decimal):
  - Regex `^\d+,\d+$` → replace(',', '.') → numeric(18,2)
  - Regex `^\d+$` → numeric(18,2)
  - Otros formatos → NULL documentado

Script aplicado:

- `sql/gate3_fact_ordenes_compra_2024_10_v2.sql`

Ejecución:

- DELETE `dw.fact_ordenes_compra` WHERE periodo='2024-10' (477.995 filas)
- INSERT v2 (477.995 filas)

Validación post-fix:

- n = 477.995
- p50 = 1.006.968
- p90 = 7.733.652
- p99 = 59.464.202
- max = 29.143.946.090
- Control table actualizada: dw.etl_control_cargas (OC 2024-10 OK)

Estado: ✅ CORREGIDO / APROBADO

---

## 2026-01-17 — Validación automatización multi-periodo

Periodos validados end-to-end:

- 2024-09
- 2024-10
- 2024-11
- 2024-12

Resultados:

- Control de cargas OK
- Sin duplicados BK+periodo
- Sin valores sentinel
- Distribuciones monetarias estables

Conclusión:
Pipeline ETL mensual validado como productivo e idempotente.

---

## 2026-01-17 — Auditoría SQL exhaustiva multi-periodo (Gate 3 / Fase 5 PASO A)

Periodos auditados: 2024-09, 2024-10, 2024-11, 2024-12

Checks ejecutados:

- dw.etl_control_cargas: OK para LIC/OC por periodo
- Conteos DW por periodo: >0 en facts
- Duplicados BK+periodo: 0 filas
- Sentinel monetario OC (>= 999e12): 0
- Percentiles OC (p50/p90/p99/max): coherentes y sin inflado

Resultados 2024-12:

- LIC: STG 359.662 → DW 312.983 (OK)
- OC : STG 411.596 → DW 373.131 (OK)
- Sentinel 2024-12: 0
- Duplicados 2024-12: 0

Conclusión:
✅ Pipeline mensual automático validado como idempotente y semánticamente estable (OC v2).
✅ PASO A (automatización) aprobado y habilita orquestación n8n (PASO A2).

---

## 2026-01-17 — Implementación Pipeline Automático Mensual (ETL DW)

Se implementa pipeline automático y reproducible para la carga mensual de datos ChileCompra al Data Warehouse.

### Componentes del pipeline

1. **cli_monthly.py**
   - Responsable de:
     - Lectura de CSV desde Data Lake (`02_INBOX/{ENTIDAD}/{PERIODO}`)
     - Normalización de columnas
     - Creación dinámica de tablas STG (`stg_lic_YYYY_MM`, `stg_oc_YYYY_MM`)
     - Carga completa en staging
   - Ejecutable de forma genérica por período.

2. **run_period.py**
   - Orquestador canónico por período.
   - Ejecuta en orden:
     1. Carga STG mensual
     2. Carga idempotente de dimensión fecha
     3. Ejecución Gate 3 (facts LIC + OC desde templates SQL)
     4. Validaciones obligatorias post-carga
     5. Registro de estado en `dw.etl_control_cargas`

3. **SQL Templates**
   - `gate3_fact_licitaciones.template.sql`
   - `gate3_fact_ordenes_compra_v2.template.sql`
   - Renderizados dinámicamente por período (`{{period}}`, `{{tag}}`).

### Contrato de Idempotencia

La tabla `dw.etl_control_cargas` gobierna la idempotencia del pipeline:

- Un período con estado `OK` para LIC y OC **no se reprocesa**
- Estados `FAILED` permiten re-ejecución controlada
- El pipeline es seguro ante múltiples ejecuciones

### Auditorías obligatorias post-carga

Para cada período:

- Unicidad BK + período
- Sentinel monetario OC (`monto_total >= 999e12`)
- Validación de percentiles
- Coherencia filas STG vs DW

### Períodos certificados

- 2024-09 → OK
- 2024-10 → OK
- 2024-11 → OK
- 2024-12 → OK

Estado del pipeline: **OPERATIVO Y ESTABLE**

---

## 2026-01-17 — CIERRE TÉCNICO PIPELINE AUTOMÁTICO MENSUAL (FASE 5)

Se implementa y valida exitosamente el **pipeline automático mensual parametrizado por periodo (YYYY-MM)**.

### Componentes implementados

- `etl/cli_monthly.py`
  - Carga genérica de CSV mensuales desde INBOX a STG:
    - `stg_lic_YYYY_MM`
    - `stg_oc_YYYY_MM`
  - Normalización de columnas
  - Carga idempotente

- `etl/run_period.py`
  - Runner canónico mensual
  - Ejecuta secuencialmente:
    1. STG mensual (cli_monthly)
    2. Carga idempotente `dim_fecha`
    3. Gate3 DW:
       - `dw.fact_licitaciones`
       - `dw.fact_ordenes_compra`
    4. Validaciones:
       - Conteo STG vs DW
       - Sentinel OC (monto_total ≥ 9.99e14)
       - Control de duplicados por BK + periodo
    5. Registro en `dw.etl_control_cargas`

- `etl/sql_templates/`
  - Templates SQL parametrizados:
    - `gate3_fact_licitaciones.template.sql`
    - `gate3_fact_ordenes_compra_v2.template.sql`

### Evidencia de ejecución real

Pipeline ejecutado exitosamente para:

- 2024-09 (piloto)
- 2024-10
- 2024-11
- 2024-12

Todos los periodos con estado `OK` en `dw.etl_control_cargas`.

### Estado

🟢 **Pipeline automático mensual cerrado y validado.**
A partir de este punto, se habilita el desarrollo de KPIs y capa analítica.

---

## 2026-01-19 — Consolidación metodológica Fase 5 (Orquestación y NO-OP)

Durante el desarrollo de la Fase 5 se produjo una evolución metodológica relevante
respecto al enfoque inicial del proyecto.

### Contexto

El objetivo inicial de la Fase 5 consideraba la automatización de la carga mensual
de datos (LIC y OC) como eje principal. Sin embargo, la evidencia empírica obtenida
durante la ejecución real del pipeline reveló la existencia de períodos con datos
válidos desde el punto de vista técnico, pero no aptos para procesamiento analítico.

Casos representativos:

- **2025-01**: anomalía estructural real en datos de LIC (fuente).
- **2025-03**: archivo OC presente pero con volumen insuficiente para ETL analítico.

### Decisión metodológica

Se redefine la prioridad de la Fase 5, estableciendo como principio rector que
la **decisión de carga debe preceder a la automatización**, incorporando el concepto
de **NO-OP (No Operation)** como una decisión explícita, auditable y válida.

NO-OP:

- No es error técnico.
- No es bloqueo del pipeline.
- No implica corrección de datos de origen.
- Protege la integridad del Data Warehouse.

### Implementación

- Se implementa un workflow en n8n que evalúa criterios objetivos de calidad
  antes de ejecutar ETL.
- La decisión RUN / NO-OP queda registrada de forma persistente en el DW
  (`dw.etl_decisiones_periodo`).
- El pipeline finaliza correctamente incluso cuando no se ejecuta ETL.

### Estado Implementación

- Fase 5: **técnicamente consolidada**
- Orquestación: **determinística, idempotente y auditable**
- Preparación para BI: **habilitada conceptualmente**

---

### 📅 2026-01-20 — Cierre técnico multi-periodo (Fase 5: Automatización + Control)

**Estado:** Validación multi-periodo ejecutada con evidencia reproducible (terminal + DW).

#### ✅ Periodos cargados y controlados (dw.etl_control_cargas)

- **2024-09:** LIC OK (STG 178.091 → DW 147.755) | OC OK (STG 396.516 → DW 324.419)
- **2024-10:** LIC OK (219.827 → 199.155) | OC OK (508.095 → 477.995)
- **2024-11:** LIC OK (530.356 → 475.782) | OC OK (470.710 → 429.335)
- **2024-12:** LIC OK (359.662 → 312.983) | OC OK (411.596 → 373.131)
- **2025-02:** LIC OK (598.982 → 452.154) | OC OK (354.933 → 316.147)
- **2025-04:** LIC OK (556.771 → 494.536) | OC OK (467.832 → 405.677)
- **2025-05:** LIC OK (538.324 → 470.000) | OC OK (438.074 → 376.060)
- **2025-06:** LIC OK (472.003 → 407.938) | OC OK (436.932 → 372.131)
- **2025-07:** LIC OK (432.435 → 372.640) | OC OK (454.386 → 382.670)
- **2025-08:** LIC OK (418.350 → 358.505) | OC OK (443.201 → 371.035)
- **2025-09:** LIC OK (312.383 → 265.167) | OC OK (408.749 → 340.311)
- **2025-10:** LIC OK (237.352 → 190.988) | OC OK (470.339 → 387.901)

#### 🟡 Periodos anómalos controlados (NO-OP / Excepción)

- **2025-01:** `EXCEPCION_FUENTE` por `LIC_SCHEMA_ANOM` (LIC con 4 columnas; archivo 155 bytes).
- **2025-03:** `NO_OP` por `OC_SIZE_ANOM` (OC 13 KB / 187 filas; LIC normal).

#### ✅ Validaciones globales ejecutadas (multi-periodo)

- Duplicados por BK+periodo:
  - LIC: 0 periodos con duplicados (consulta retorna 0 filas).
  - OC : 0 periodos con duplicados (consulta retorna 0 filas).
- Sentinel monetario OC (`monto_total >= 999e12`): 0 (consulta retorna 0 filas).
- Distribución monetaria OC por periodo (p50/p90/p99/max): coherente y sin inflado (evidencia SQL).

#### 📌 Evidencias generadas (reproducibles)

Carpeta: `evidencias/fase5_cierre_2026-01-20/`

- `02_etl_control_cargas_full.txt`
- `03_etl_decisiones_periodo_full.txt` / `03b_noop_periodos_controlados.txt`
- `06_dup_lic_por_periodo.txt` / `07_dup_oc_por_periodo.txt`
- `08_sentinel_oc_por_periodo.txt`
- `09_percentiles_oc_por_periodo.txt`
- `10_inbox_lic_tree.txt` / `11_inbox_oc_tree.txt` / `12_inbox_files_por_periodo.txt`

#### 🧾 Observaciones registradas

- **Incidente operativo controlado (2025-04):** se registra evento `NO_OP MISSING_DIR` previo a la carga OK (corrección de naming de carpeta en INBOX). No hubo contaminación del DW.
- **INBOX no contiene 2024-09:** periodo histórico cargado previamente al esquema INBOX actual; no afecta DW ni control de cargas.

**Dictamen auditor:** Fase 5 queda técnicamente cerrable y habilita transición a Gate BI (Power BI) bajo reglas de `docs/fase5/`.

---

#### ✅ Validación de integridad referencial (multi-periodo)

Se ejecutaron checks de NULLs en SKs para validar integridad del modelo estrella.

**Hechos y SKs de negocio (organismo/proveedor/producto):**

- `dw.fact_licitaciones`: `organismo_sk`, `proveedor_sk`, `producto_onu_sk` → **0 NULL en todos los periodos**
- `dw.fact_ordenes_compra`: `organismo_sk`, `proveedor_sk`, `producto_onu_sk` → **0 NULL en todos los periodos**

**Fechas (comportamiento esperado por calidad de fuente):**

- `dw.fact_licitaciones.fecha_cierre_sk` presenta NULLs por periodo (licitaciones sin fecha de cierre registrada / no aplicable en fuente).
- `dw.fact_ordenes_compra.fecha_aceptacion_sk` presenta NULLs por periodo (OC sin fecha de aceptación registrada / estado operativo).

**Regla metodológica para BI:**

- BI no “reconstruye” fechas faltantes.
- KPIs basados en fecha de cierre/aceptación deben filtrar o tratar NULL explícitamente.

**Evidencia:**

- `evidencias/fase5_cierre_2026-01-20/13_fk_nulls_lic_por_periodo.txt`
- `evidencias/fase5_cierre_2026-01-20/14_fk_nulls_oc_por_periodo.txt`
- `evidencias/fase5_cierre_2026-01-20/15_dim_counts.txt`

---

### 📅 2026-01-20 — Consolidación real de Fase 5 (post-ejecución)

Durante la ejecución efectiva multi-periodo del pipeline,
la Fase 5 evoluciona desde una definición conceptual
a una implementación real controlada mediante n8n.

Se valida:

- ejecución idempotente,
- decisiones NO-OP y EXCEPCIÓN_FUENTE,
- control de integridad analítica.

La automatización deja de ser hipotética y pasa a ser
**operativa, pero gobernada por reglas analíticas**.

### 📅 2026-01-20 — Cierre técnico y metodológico de Fase 5

Se da por cerrada la Fase 5 del proyecto **ChileCompra Data Platform**,
correspondiente a la consolidación analítica CLEAN → Data Warehouse.

A esta fecha se valida:

- ejecución idempotente multi-periodo,
- control explícito de duplicados,
- decisiones RUN / NO-OP / EXCEPCIÓN_FUENTE registradas por periodo,
- preservación de la integridad del Data Warehouse,
- trazabilidad completa desde Data Lake hasta modelo analítico.

La Fase 5 queda cerrada desde el punto de vista técnico y metodológico,
habilitando el paso a la fase de explotación BI sin necesidad de
reprocesamientos históricos.

Se da por cerrada la Fase 5 tras la validación completa de periodos históricos, la gestión explícita de excepciones y la confirmación de integridad referencial del DW.

**Estado:** Validación multi-periodo ejecutada con evidencia reproducible
(terminal + DW).

- Periodos cargados y controlados: `2024-09` a `2025-10`
- Periodos NO-OP documentados: `2025-01`, `2025-03`
- Integridad referencial preservada
- DW listo para explotación BI

**Estado global:** Fase 5 **CERRADA**

---

## ✅ CIERRE FASE BI — Contrato de KPIs

**Fecha:** 2026-01-22  
**Estado:** CERRADA FORMALMENTE

Se completa y valida la Fase BI-0 del TFM ChileCompra Data Platform.

### Evidencias de cierre

- Entorno BI reproducible validado (Conda + Python 3.10.19).
- Conectividad PostgreSQL verificada desde notebooks BI.
- Contrato de KPIs definido y ejecutado vía SQL.
- Oráculo de KPIs generado y versionado:
  - `bi0_estado_periodos.csv`
  - `bi0_oraculo_kpis.csv`
  - `bi0_oraculo_kpis_pivot.csv`
- Exclusión explícita de reclamos documentada (no disponibles en DW).

### Artefactos

Ruta evidencia:
`docs/evidence/fase5_BI/`

Notebooks:

- `TFM_Fase5_BI_00_Check_Entorno.ipynb`
- `TFM_Fase5_BI_01_Contrato_KPIs_SQL.ipynb`
- `TFM_Fase5_BI_01_Contrato_KPIs_SQL_v2_sin_reclamos.ipynb`

### Decisión

BI-0 queda congelada como **baseline analítica oficial** para diseño BI (Power BI).
No se agregan nuevos KPIs sin abrir Gate BI.

✔️ Fase BI cerrada.

---

### 📅 2026-01-23 — Clarificación del modo operativo del ETL

**Contexto:**
Durante la revisión técnica de la Fase 5 se identificó una posible ambigüedad
interpretativa respecto al rol del contenedor ETL, al estar implementado sobre
FastAPI y Docker.

**Análisis:**
Se confirma que el ETL del proyecto fue diseñado y validado como un proceso
batch mensual, ejecutado por período y no como un servicio de disponibilidad
continua. La ingestión vía API ChileCompra no pudo ser utilizada debido a la
no entrega de credenciales por parte del proveedor, situación previamente
documentada como dependencia externa.

**Decisión:**
Se ratifica oficialmente que:

- el ETL opera en modalidad batch por período,
- la descarga manual mensual de archivos OC y LIC constituye la fuente operativa,
- la ausencia de ejecución permanente del contenedor ETL no compromete la reproducibilidad del proyecto ni la validez de las fases BI, las cuales se sustentan en el Data Warehouse validado.

Esta aclaración se incorpora como decisión técnica consciente y queda registrada
para fines de auditoría académica.

---

### 📅 2026-01-24 — Cierre incidente operativo pgAdmin / PostgreSQL (ruido de logs)

**Contexto:**
Durante la estandarización de scripts de operación (`02-tfm.sh`, `03-status.sh`)
se detectó en los logs de PostgreSQL el mensaje:

`FATAL: database "chile_user" does not exist`

**Diagnóstico:**

- El mensaje corresponde a intentos históricos o tempranos de conexión
  usando el nombre de usuario como base de datos.
- No existe impacto funcional ni estructural.
- El Data Warehouse, ETL y BI operan con normalidad sobre la DB `chilecompra`.

**Acciones realizadas:**

- Validación completa del stack mediante `03-status.sh`.
- Reconfiguración limpia de pgAdmin (volumen reset).
- Confirmación de no recurrencia del mensaje en ventanas operativas.

**Decisión:**

- El evento se clasifica como **ruido histórico de arranque**.
- No se crean bases de datos artificiales para silenciar logs.
- Se mantiene arquitectura limpia y consistente.

**Estado:** Incidente cerrado — sin impacto técnico ni académico.

---

## 📅 2026-01-24 — Inicio Gate BI-1: Modelo Semántico Power BI

**Fase:** BI — Gate BI-1  
**Periodo piloto:** 2024-09  
**Fuente:** Data Warehouse `dw` (PostgreSQL)

### Contexto a la fecha

Con la Fase 5 cerrada técnica y metodológicamente, y el DW validado
para múltiples periodos, se autoriza el inicio del **Gate BI-1**,
orientado a la construcción del modelo semántico en Power BI.

El objetivo del Gate BI-1 es validar que:

- el modelo estrella del DW es explotable analíticamente,
- las relaciones 1:* funcionan correctamente,
- las medidas DAX respetan el contrato BI-0,
- los resultados BI cuadran con el oráculo SQL.

### Acciones ejecutadas

- Conexión directa Power BI ↔ PostgreSQL (`dw`).
- Construcción del modelo estrella:
  - Dimensiones: fecha, organismo, proveedor, producto_onu
  - Hechos: licitaciones, órdenes de compra
- Relaciones 1:* con filtro single direction (dim → fact).
- Creación de medidas base:
  - Conteos LIC / OC
  - Montos OC (segmentados por moneda).
- Página de reconciliación:
  - `RECON_2024_09`

### Evidencias

Ruta:
`docs/evidence/fase5_BI/powerbi/`

- `capturas/01_modelo_relaciones.png`
- `sql/recon_2024_09.sql`
- `sql/recon_2024_09.log`

Los valores obtenidos en Power BI coinciden con los resultados
obtenidos vía SQL sobre el DW.

### Estado a la fecha

Gate BI-1: **EN CURSO (validación semántica)**  
Riesgo académico: **BAJO**  
Riesgo técnico: **CONTROLADO**

---

## 🧾 ACTAS Y AUDITORÍAS — FASE 5 (Gate 3)

Entre **2026-01-15 y 2026-01-20** se ejecuta y valida completamente:

- Implementación DW analítico
- Correcciones semánticas críticas (monetario OC)
- Validaciones SQL nivel 1 a 5
- Control de duplicados
- Integridad referencial
- Idempotencia multi-periodo
- Decisiones NO-OP y EXCEPCIÓN_FUENTE

Todos los eventos detallados en esta sección corresponden a
**ejecución real, evidenciada y cerrada**.

---

### 📅 2026-01-20 — Implementación técnica multi-periodo (Fase 5)

#### Implementación (workflow y control)

- Se implementó un workflow en n8n que evalúa criterios objetivos de calidad
  antes de ejecutar ETL.
- La decisión RUN / NO-OP queda registrada de forma persistente en el DW
  (`dw.etl_decisiones_periodo`).
- El pipeline finaliza correctamente incluso cuando no se ejecuta ETL.

#### Estado de la implementación (Fase 5)

- Fase 5: **técnicamente consolidada**
- Orquestación: **determinística, idempotente y auditable**
- Preparación para BI: **habilitada conceptualmente**

---

### 📅 2026-01-20 — Cierre técnico multi-periodo (Fase 5)

**Estado:** Validación multi-periodo ejecutada con evidencia reproducible
(terminal + DW).

- Periodos cargados y controlados: `2024-09` a `2025-10`
- Periodos NO-OP documentados: `2025-01`, `2025-03`
- Integridad referencial preservada
- DW listo para explotación BI

**Estado global:** Fase 5 **CERRADA**

---

## 📌 Referencias de cierre formal

Los siguientes documentos constituyen el cierre formal del proyecto
hasta Fase 5:

- `docs/fase5/08_estado_actual_fase5.md` — Estado oficial del proyecto
- `docs/fase5/01_mapa_impacto_implementacion_fase5.md` — Contrato histórico de ejecución
- `docs/fase5/06_modelo_bi_powerbi.md` — Modelo BI no correctivo
- `docs/fase5/07_checklist_verificacion_bi_pre_tfm.md` — Verificación BI

---

### 📅 2026-01-24 — Inicio Gate BI-1 (Power BI)

Con Fase 5 cerrada, se autoriza Gate BI-1 para validación del modelo
semántico en Power BI.

**Estado:** BI-1 **EN CURSO (validación)**  
**Riesgo académico:** BAJO  
**Riesgo técnico:** CONTROLADO

---

## Justificación de cierres múltiples en Fase 5

La presencia de múltiples bloques de “Implementación” y “Cierre” asociados
a la Fase 5 **no constituye una incoherencia**, sino una **decisión
metodológica deliberada**.

La Fase 5 se documenta desde **distintos niveles de abstracción**, cada uno
con un propósito específico y no redundante:

- **Cierre técnico puntual (Gate 3):**  
  Documenta la correcta implementación del Data Warehouse analítico,
  la resolución de hallazgos técnicos y la validación estructural del modelo.

- **Cierre técnico multi-periodo:**  
  Documenta la validación del pipeline automático sobre múltiples períodos,
  incluyendo control de idempotencia, decisiones NO-OP y evidencia
  reproducible de ejecución.

- **Cierre metodológico de Fase 5:**  
  Documenta el sellado académico de la fase, confirmando que no se
  permiten reinterpretaciones, reprocesamientos ni correcciones
  posteriores en capas superiores (BI).

Cada cierre responde a un **nivel distinto de control** (técnico,
operativo y metodológico) y su coexistencia refuerza la trazabilidad,
la auditabilidad y la defensa académica del proyecto.

La Fase 5 se considera **cerrada una única vez en términos de estado
del proyecto**, pero **documentada desde múltiples perspectivas**
para asegurar rigor y claridad ante evaluación externa.

---

## Declaración final

Este Project Log se mantiene como **registro histórico consolidado**.
No define tareas futuras ni modifica el estado del proyecto.

Cualquier cambio posterior debe quedar registrado
en los documentos de fase correspondientes.

---

### 📅 2026-01-28 — Evidencias Pre-BI LIC–OC (Hallazgos)

**Fase:** BI (Pre-BI)  
**Estado:** ANÁLISIS / DIAGNÓSTICO (sin cierre semántico)

#### Contexto Pre-BI

En el marco de la preparación de la capa BI, se ejecutó un análisis exploratorio de los campos críticos **Moneda** y **Sector del Estado** para los dominios **LIC** y **OC**, con el objetivo de identificar inconsistencias semánticas y riesgos analíticos antes de avanzar con Power BI.

Este análisis **no introduce decisiones finales de modelo**, sino que documenta exclusivamente **hallazgos empíricos** a partir de los datos existentes en el DW.

#### Hallazgos — Moneda

- **LIC** reporta moneda en formato descriptivo:
  - `Peso Chileno`
  - `Dolar`
  - `Unidad de Fomento`
  - `Moneda revisar`
- **OC** reporta moneda en formato codificado:
  - `CLP`, `USD`, `CLF`, `UTM`, `EUR`

**Riesgo identificado:**  
La coexistencia de descripciones textuales y códigos normalizados impide agregaciones directas y genera ambigüedad semántica en la capa BI si no se define una normalización previa en DW.

#### Hallazgos — Sector del Estado

- El campo fuente es `dw.dim_organismo.tipo_organismo`.
- Se observan categorías válidas y recurrentes (municipalidades, salud, gobierno central, etc.).
- Existen registros con `tipo_organismo` vacío o no informado.

**Riesgo identificado:**  
La ausencia de un tratamiento explícito de valores faltantes puede inducir imputaciones implícitas o categorizaciones inconsistentes en la capa BI.

#### Conclusión Pre-BI

Los hallazgos evidencian la necesidad de:

- Definir una **capa semántica explícita en DW** para Moneda y Sector.
- Evitar resolver semántica directamente en Power BI.
- Preservar trazabilidad DW → BI y no imputar valores faltantes.

> **Nota:**  
> Las decisiones finales de normalización, catálogos cerrados y flags de calidad se formalizan posteriormente en el cierre de los gates semánticos (ver entrada 2026-01-29).

**Evidencia:**

- `docs/evidence/fase6_BI/02_Evidence_PreBI_LIC_OC.ipynb`

**Aclaración:**

- Esta entrada no constituye cierre semántico. El cierre formal se realiza en la entrada 2026-01-29.

---

### 📅 2026-01-29 — Gate BI-Sem-1 (Moneda) y Gate BI-Sem-2 (Sector) — CIERRE FORMAL (DW → BI)

**Contexto (Fase BI / Pre-BI):**  
Previo a avanzar con Power BI, se cerró explícitamente una **capa semántica auditable en DW** para **Moneda** y **Sector del Estado**, evitando cualquier lógica semántica en Power BI y preservando trazabilidad **DW → BI**.  
Evidencias en `docs/evidence/fase6_BI/`.

## ✅ Gate BI-Sem-1 — Moneda (CERRADO)

**Problema observado (evidencia):**  

- **LIC** reporta moneda en formato descriptivo: `Peso Chileno`, `Dolar`, `Unidad de Fomento`, `Moneda revisar`.  
- **OC** reporta moneda en códigos: `CLP`, `USD`, `CLF`, `UTM`, `EUR`.  

**Decisión de modelo (catálogo cerrado):**  
Se congela el catálogo cerrado de `moneda_norm`:

- `CLP` (Peso Chileno)  
- `USD` (Dólar)  
- `CLF` (UF / Unidad de Fomento)  
- `UTM` (Unidad Tributaria Mensual)  
- `EUR` (Euro)

**Reglas obligatorias:**  

- No se realizan conversiones monetarias.  
- Fuera de catálogo → `moneda_norm = NULL` y `flag_moneda_unknown = 1`.  
- BI debe segmentar por moneda (no sumar monedas distintas).

**Implementación en DW (no destructiva):**  

- Se implementa en **vistas** del esquema `dw_sem` (sin modificar `dw.*` ni ETL).  
- Vistas estables consumibles por BI:
  - `dw_sem.v_fact_licitaciones_sem`
  - `dw_sem.v_fact_ordenes_compra_sem`
- Se aplica patrón seguro para no romper Power BI:
  - creación de vistas versionadas `*_sem_v2`
  - validación de contrato (mismas columnas/tipos)
  - switch atómico de vistas estables a `SELECT * FROM *_sem_v2`

**Evidencia (notebooks):**

- `docs/evidence/fase6_BI/02_Evidence_PreBI_LIC_OC.ipynb`
- `docs/evidence/fase6_BI/03_DW_Semantica_Moneda_Sector.ipynb`

**Estado:** ✅ Gate BI-Sem-1 (Moneda) **CERRADO**

## ✅ Gate BI-Sem-2 — Sector del Estado (CERRADO)

**Campo fuente (único):**  

- `dw.dim_organismo.tipo_organismo`

**Decisión de modelo (catálogo cerrado):**  
Se normaliza `sector_estado_norm` desde `tipo_organismo` a un catálogo cerrado:

- `MUNICIPALIDADES`
- `SALUD`
- `GOB_CENTRAL_UNIVERSIDADES`
- `OTROS`
- `OBRAS_PUBLICAS`
- `FFAA`
- `LEGISLATIVO_JUDICIAL`

**Reglas obligatorias:**  

- No se imputan sectores faltantes.  
- Vacío/NULL → `sector_estado_norm = NULL` y `flag_sector_missing = 1`.  
- Fuera de catálogo → `sector_estado_norm = NULL` y `flag_sector_unknown = 1`.

**Implementación en DW (no destructiva):**  

- Se implementa en vistas del esquema `dw_sem` (sin modificar `dw.*` ni ETL).  
- Vista estable consumible por BI:
  - `dw_sem.v_dim_organismo_sem`
- Patrón seguro para no romper Power BI:
  - creación de `dw_sem.v_dim_organismo_sem_v2`
  - validación de contrato (mismas columnas/tipos)
  - switch atómico de la vista estable a `SELECT * FROM v2`

**Evidencia (notebooks):**

- `docs/evidence/fase6_BI/02_Evidence_PreBI_LIC_OC.ipynb`
- `docs/evidence/fase6_BI/03_DW_Semantica_Moneda_Sector.ipynb`

**Estado:** ✅ Gate BI-Sem-2 (Sector) **CERRADO**

## Impacto y habilitación (DW → BI)

- El DW queda con **capa semántica explícita y auditable** en `dw_sem`.  
- Power BI debe consumir **solo** vistas `dw_sem.*` (no aplicar semántica en BI).  
- Se habilita avanzar en Power BI como capa de visualización, manteniendo:
  - sin imputación
  - sin corrección de datos fuente
  - sin conversión de monedas
  - trazabilidad DW → BI

---

## 2026-01-29 BI – Normalización de dimensión Organismo

- Se elimina relación con dw_sem.v_dim_organismo_sem (SEM v1)
- Se consolida uso exclusivo de dw.dim_organismo
- Facts v2 (licitaciones y OC) validados sin claves huérfanas
- Modelo BI queda canónico y sin ambigüedad semántica
- No se incorpora dw_sem.v_dim_organismo_sem_v2 al modelo BI al no ser requerida

---
