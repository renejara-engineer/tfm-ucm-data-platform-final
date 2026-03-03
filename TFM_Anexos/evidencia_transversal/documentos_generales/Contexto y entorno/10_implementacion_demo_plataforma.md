# TFM — Diseño e implementación demo Plataforma  

## Objetivo

Este documento describe la implementación operativa del modelo arquitectónico consolidado, configurado en un entorno DEMO reproducible para efectos de validación académica.

---

## 1. Principio rector: reproducibilidad sin publicar datos masivos

Los datos oficiales de contratación pública presentan un volumen elevado (archivos mensuales de cientos de MB hasta varios GB).  
Por tanto, **no es viable ni recomendable publicarlos en GitHub**.

Sin embargo, la solución debe ser:

- ejecutable por terceros
- verificable con evidencia reproducible
- coherente con el modelo DW y BI desarrollado

Esto se resuelve mediante la definición de dos modos de operación.

---

## 2. Entorno REAL (operación completa)

### 2.1 Objetivo

El entorno REAL representa la ejecución completa del pipeline con:

- dataset histórico completo (múltiples períodos mensuales)
- volumen real de datos
- integración completa en Data Lake y Data Warehouse

Este entorno se utiliza para:

- construcción del DW y modelo semántico final
- validación de escalabilidad
- generación de resultados analíticos completos
- auditoría DW → BI

### 2.2 Características técnicas

- Data Lake ubicado fuera del repositorio GitHub (ej. disco externo o ruta local)
- ejecución completa del pipeline ETL sobre múltiples períodos
- carga real en PostgreSQL (DW y esquema semántico)

### 2.3 Evidencias del entorno REAL

Las evidencias asociadas a REAL no consisten en publicar datasets masivos, sino en publicar:

- conteos SQL verificables
- logs de ejecución docker
- hashes (sha256) de archivos procesados
- outputs resumidos (CSV pequeños de resultados, no datos originales)

Esto permite demostrar ejecución real sin exponer datos masivos.

---

## 3. Entorno DEMO (reproducibilidad GitHub)

### 3.1 Objetivo

El entorno DEMO corresponde a un stack reproducible para terceros, cuyo propósito es demostrar:

- arquitectura completa funcional
- automatización (n8n)
- ejecución del pipeline ETL
- carga en Data Warehouse
- control operacional y trazabilidad

El entorno DEMO está diseñado para ejecutarse en pocos minutos, usando un subconjunto mínimo de datos.

### 3.2 Características técnicas

- Data Lake incluido como estructura (skeleton) en el repositorio (`data/ChileCompraDL`)
- dataset mínimo (por ejemplo 1 período mensual reducido)
- docker compose portable para levantar servicios
- workflow n8n exportado y versionado

### 3.3 Evidencias del entorno DEMO

El repositorio GitHub incluye evidencia ligera y reproducible, por ejemplo:

- archivos `.env.example` y `.env.demo` sin secretos
- scripts de validación
- logs de contenedores
- capturas y outputs de ejecución
- export del workflow n8n (`n8n/workflows/TFM_WorkFlow.json`)

---

## 4. Diferencias clave entre REAL y DEMO

| Dimensión | Entorno REAL | Entorno DEMO |
|----------|--------------|--------------|
| Dataset | Completo (histórico) | Reducido (1 período o subset) |
| Publicación GitHub | No se publica | Sí se publica |
| Objetivo | Validación completa y resultados finales | Reproducibilidad externa |
| Evidencia | Hashes, conteos, logs, outputs resumidos | Logs DEMO, workflow, scripts, dataset mínimo |
| Tiempo de ejecución | Alto (dependiente de volumen) | Bajo (minutos) |

---

## 5. Regla de coherencia metodológica (TFM)

La solución se describe en el informe académico como un único sistema, pero se ejecuta en dos modalidades.

- **El entorno REAL valida escalabilidad y resultados completos.**
- **El entorno DEMO valida reproducibilidad externa.**

Ambos entornos comparten:

- el mismo pipeline ETL
- el mismo modelo lógico del DW
- la misma arquitectura dockerizada
- el mismo workflow n8n

La diferencia reside únicamente en:

- volumen de datos
- política de publicación (GitHub)

---

## 6. Nota para notebooks y anexos

Todos los notebooks y evidencias deben indicar explícitamente si corresponden a:

- ejecución REAL (outputs del DW completo)
- ejecución DEMO (dataset reducido)

Esto asegura coherencia académica y evita ambigüedad ante el tribunal.

---

## 7. Conclusión

La existencia de dos entornos no representa una limitación del proyecto, sino una decisión de diseño alineada con:

- principios de ingeniería reproducible
- buenas prácticas de publicación en GitHub
- restricciones reales de tamaño y portabilidad

Este enfoque permite demostrar:

- arquitectura funcional reproducible
- ejecución real a escala con evidencia verificable

---
