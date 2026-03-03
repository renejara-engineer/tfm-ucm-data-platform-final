# TFM — Diseño e implementación de un sistema ETL automatizado para la integración y análisis de datos abiertos de contratación pública  

**Universidad Complutense de Madrid (UCM)**  
**Máster en Data Science e Inteligencia Artificial**  
**Trabajo Fin de Máster (TFM)**

## 1. Propósito del documento

Este documento define los **HITOS oficiales (Milestones)** del desarrollo del TFM bajo la modalidad UCM  
**Opción 2: Pipeline de preparación/disponibilización de datos**.

El objetivo es proporcionar una estructura clara, verificable y defendible ante tribunal, asegurando trazabilidad entre:

- **avance del proyecto**
- **artefactos técnicos implementados**
- **documentación del repositorio**
- **evidencia reproducible**
- **capítulos del informe académico**

Este documento actúa como guía de seguimiento y como índice conceptual del repositorio.

---

## 2. Definición formal de Hito (criterio metodológico)

En el contexto de gestión de proyectos, un **hito** representa un **punto de control relevante** que marca la finalización de un conjunto de actividades y entregables críticos.  
Un hito no corresponde a una tarea aislada, sino a un evento verificable que confirma progreso estructural.

En este TFM, un hito se considera alcanzado únicamente si existen:

- entregables explícitos
- evidencia reproducible (logs, SQL, outputs, scripts)
- documentación que permite auditar el resultado

---

## 3. Principio rector: evidencia reproducible y separación DEMO vs REAL

Este TFM opera bajo dos entornos no equivalentes pero metodológicamente coherentes:

- **REAL:** ejecución completa con dataset histórico (no publicable por volumen)  
- **DEMO:** ejecución mínima reproducible y publicable en GitHub

La separación está formalizada en el documento oficial:  
`docs/00_entornos_demo_vs_real.md`

El repositorio GitHub corresponde al **anexo digital reproducible**, por lo que la evidencia debe ser ligera pero verificable.

---

## 4. Reglas para declarar un HITO como “cerrado”

Un hito se declara cerrado si cumple simultáneamente:

1. Existe un artefacto técnico real (script, docker compose, SQL, workflow n8n, modelo BI).  
2. Existe evidencia reproducible (output/log o comando verificable).  
3. Existe documentación formal que explica alcance y decisiones.  
4. No existe contradicción con el estado oficial del proyecto (jerarquía documental vigente).

En particular, el estado de Data Warehouse y cargas históricas está normado por:  
`docs/fase5/08_estado_actual_fase5.md`

---

# 5. HITOS oficiales del proyecto

---

## 🟩 HITO 1 — Definición formal del TFM (✔ CERRADO)

**Propósito:**  
Definir alcance, objetivos, caso de uso y restricciones académicas/técnicas.

**Entregables:**

- objetivos generales y específicos
- caso de uso formal
- definición de fuentes de datos ChileCompra
- periodo de análisis definido
- restricciones conocidas (ej. API no disponible en ciertas etapas)

**Artefactos:**

- `docs/01_TFM_Scoping_Oficial.md`

**Criterio de cierre:**  
El tribunal puede comprender con claridad qué se construye, por qué y para qué.

✔ **Cerrado**

---

## 🟩 HITO 2 — Definición de arquitectura global y narrativa académica (✔ CERRADO)

**Propósito:**  
Definir la arquitectura del sistema desde dos perspectivas:

- técnica (implementación real)
- académica (narrativa para memoria)

**Entregables:**

- arquitectura técnica en Docker
- descripción académica del aporte del TFM
- separación conceptual por capas (Data Lake / ETL / DW / Orquestación / BI)

**Artefactos:**

- `docs/02_architecture_tecnica_ver1.md`
- `docs/03_architecture_academia_ver1.md`

**Criterio de cierre:**  
Existe una arquitectura defendible y coherente con el repositorio reproducible.

✔ **Cerrado**

---

## 🟩 HITO 3 — Infraestructura reproducible en Docker (✔ CERRADO)

**Propósito:**  
Implementar infraestructura local reproducible para ejecutar el pipeline completo.

**Entregables:**

- stack dockerizado funcional (Postgres + ETL + n8n + PGAdmin)
- configuración portable mediante `.env`
- validación de conectividad entre servicios

**Artefactos:**

- docker compose (REAL y DEMO)
- `.env.example`
- scripts de operación en raíz

**Criterio de cierre:**  
El stack puede levantarse sin intervención manual compleja.

✔ **Cerrado**

---

## 🟩 HITO 4 — Data Lake por zonas (RAW → CLEAN → MART) (✔ CERRADO)

**Propósito:**  
Estandarizar el almacenamiento por zonas para soportar procesamiento incremental.

**Entregables:**

- estructura formal por dominio (LIC/OC/Organismos)
- convención temporal por periodo
- consistencia de rutas y naming

**Artefactos:**

- scripts de inicialización de datalake
- documentación de bitácora

**Criterio de cierre:**  
El Data Lake posee estructura reproducible y coherente con el pipeline.

✔ **Cerrado**

---

## 🟩 HITO 5 — Implementación del pipeline ETL RAW→CLEAN y CLEAN→MART (✔ CERRADO)

**Propósito:**  
Implementar pipeline ETL por etapas para normalizar y preparar datos analíticos.

**Entregables:**

- scripts de transformación por dominio
- tipificación y limpieza controlada
- consolidación a datasets mart

**Artefactos:**

- módulo ETL dockerizado
- scripts y librerías internas del ETL

**Criterio de cierre:**  
El pipeline genera outputs estandarizados en CLEAN/MART y permite carga DW.

✔ **Cerrado**

---

## 🟩 HITO 6 — Data Warehouse implementado y validado (✔ CERRADO)

**Propósito:**  
Implementar un DW relacional en PostgreSQL (modelo analítico) y validar cargas históricas.

**Entregables:**

- esquemas DW implementados
- tablas de hechos y dimensiones
- control de cargas por periodo
- decisiones formales de NO-OP y EXCEPCIÓN_FUENTE

**Artefacto normativo principal:**

- `docs/fase5/08_estado_actual_fase5.md`

**Criterio de cierre:**  
La plataforma DW está cerrada y estable; no se realizan cambios estructurales previos a BI.

✔ **Cerrado**

---

## 🟩 HITO 7 — Contrato analítico BI-0 (KPIs definidos y congelados) (✔ CERRADO)

**Propósito:**  
Definir KPIs oficiales y criterios de validación analítica previos a BI.

**Entregables:**

- KPIs definidos formalmente
- criterios SQL de validación obligatoria
- decisión metodológica de no imputar inconsistencias en BI

**Artefactos:**

- documentación BI en fase5

**Criterio de cierre:**  
Existe contrato KPI auditable; BI no redefine métricas.

✔ **Cerrado**

---

## 🟩 HITO 8 — Modelo BI Power BI implementado y auditado (✔ CERRADO)

**Propósito:**  
Construir modelo semántico y dashboards Power BI como capa de evidencia.

**Entregables:**

- modelo semántico coherente con DW
- dashboards separados LIC/OC
- hoja técnica RECON como Gate BI-1
- trazabilidad DW→DAX→KPI validada

**Artefactos:**

- `docs/fase5/06_modelo_bi_powerbi.md`
- `docs/fase5/07_checklist_verificacion_bi_pre_tfm.md`

**Criterio de cierre:**  
BI se valida como capa de evidencia, no como capa de corrección.

✔ **Cerrado**

---

## 🟩 HITO 9 — Orquestación n8n implementada y versionada (✔ CERRADO)

**Propósito:**  
Automatizar ejecución del pipeline mediante workflow n8n reproducible.

**Entregables:**

- workflow exportado y versionado
- ejecución vía HTTP hacia ETL
- trazabilidad de ejecución y logs

**Artefactos:**

- workflow JSON en carpeta `n8n/`
- evidencia asociada en `docs/evidence/n8n/`

**Criterio de cierre:**  
El workflow se puede importar y ejecutar en stack DEMO.

✔ **Cerrado**

---

## 🟩 HITO 10 — Entorno DEMO reproducible publicable en GitHub (✔ CERRADO)

**Propósito:**  
Publicar una versión reproducible del proyecto sin datos masivos, pero con evidencia funcional.

**Entregables:**

- docker compose DEMO portable
- dataset mínimo o skeleton de datalake
- `.env.demo` seguro
- scripts de validación
- evidencia de ejecución reproducible

**Artefacto normativo:**

- `docs/00_entornos_demo_vs_real.md`

**Criterio de cierre:**  
Un tercero puede levantar el stack y verificar ejecución de extremo a extremo.

✔ **Cerrado**

---

## 🟨 HITO 11 — EDA clásico académico (Anexo formal) (⏳ EN CURSO)

**Propósito:**  
Generar un EDA clásico resumido (estadística descriptiva, nulos, outliers, frecuencias) como evidencia estándar académica.

**Entregables:**

- notebook reproducible de EDA sobre DW_SEM
- outputs exportables para anexos

**Artefactos:**

- notebook de anexo EDA (por definir ruta final)

**Criterio de cierre:**  
EDA estándar disponible como anexo, sin contradecir auditoría DW→BI.

⏳ En curso

---
