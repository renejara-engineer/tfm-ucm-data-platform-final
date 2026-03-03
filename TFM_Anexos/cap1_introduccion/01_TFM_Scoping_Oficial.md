# 01 — TFM Scoping Oficial  

**TFM: Plataforma de Ingeniería de Datos para Compras Públicas de Chile (ChileCompra Data Platform)**  

Versión: 1.0  
Autor: René Alberto Jara Balboa  
Programa: Máster en Ciencia de Datos e Inteligencia Artificial — Universidad Complutense de Madrid  
Modalidad seleccionada: **Opción 2 — Pipeline de datos, integración y disponibilización**

---

## 1. Contexto institucional

El sistema de compras públicas de Chile —administrado por la Dirección ChileCompra mediante la plataforma Mercado Público— gestiona la adquisición de bienes y servicios del Estado. El ecosistema está regulado por estándares de transparencia, probidad y trazabilidad, y supervisado por entidades como la Contraloría General de la República y el Consejo para la Transparencia.

Durante los años 2024–2025 se ha evidenciado una creciente necesidad institucional de:

- unificación de datos actualmente dispersos,  
- interoperabilidad entre organismos,  
- monitoreo y auditorías basadas en evidencia,  
- análisis de eficiencia, competencia y riesgo,  
- herramientas reproducibles para toma de decisiones.

---

## 2. Justificación del proyecto

Actualmente existen datos estructurados disponibles (licitaciones, órdenes de compra, catálogo de instituciones), pero no existe un pipeline unificado, reproducible y analizable que permita generar métricas consistentes de comportamiento del gasto público.  
Este TFM aborda la brecha **no desde la analítica exploratoria**, sino desde la ingeniería de datos, mediante una arquitectura modular, ejecutable y versionada.

---

## 3. Caso de uso oficial

> **Evaluar el comportamiento de las compras públicas en Chile entre octubre 2024 y noviembre 2025 mediante un pipeline reproducible que integre datos estructurados de licitaciones, órdenes de compra y catálogo institucional, para generar indicadores de riesgo, eficiencia y competencia institucional.**

---

## 4. Objetivo general

Diseñar e implementar una plataforma de ingeniería de datos que permita extraer, transformar, integrar y disponibilizar datos estructurados del sistema de compras públicas de ChileCompra, generando una base analítica y métricas reproducibles para evaluación institucional.

---

## 5. Objetivos específicos

1. Construir un Data Lake estructurado en niveles RAW/CLEAN.  
2. Implementar pipelines ETL modulares y orquestables.  
3. Modelar un Data Warehouse dimensional en PostgreSQL.  
4. Calcular indicadores clave (competencia, riesgo, eficiencia).  
5. Desarrollar dashboards analíticos con visualizaciones funcionales.  
6. Incorporar orquestación con **n8n** para automatización y reporting.  
7. Documentar reproducibilidad, versionado y arquitectura final.  
8. (Opcional validado): Integrar un agente de lenguaje natural (LangGraph) como capa de consumo, sin afectar el pipeline central.

---

## 6. Alcance técnico (IN/OUT)

### **Incluye (IN):**

| Elemento                                              | Incluido |
|-------------------------------------------------------|----------|
| Pipeline RAW → CLEAN → DW                             | ✔        |
| ETL en Python (Dockerizado)                           | ✔        |
| PostgreSQL como base analítica                        | ✔        |
| Orquestación con n8n                                  | ✔        |
| Dashboards (Power BI o equivalente)                   | ✔        |
| Scripts de automatización, versionado Git             | ✔        |
| Replicabilidad con `docker-compose` + documentación   | ✔        |

### **Excluye (OUT):**

| Elemento                                                                | Excluido                               |
|-------------------------------------------------------------------------|----------------------------------------|
| Auditoría jurídica o legal                                              | ✘ (parcialmente)                                     |
| Modelos predictivos avanzados (ML)                                      | ✘ (mejora futura)                      |
| Agente IA - Análisis documentaicon anexa a LIC y/o OC                  | ✘ (mejora futura)                                     |
| Trazabilidad completa LP ↔ OC (si complejidad excede tiempo disponible) | ✘ (documentada como limitación viable) |

---

## 7. Arquitectura propuesta (versión operacional actual)

![Arquitectura operacional](./assets/architecture.png)

Infraestructura actual confirmada en ejecución:

- Docker + docker-compose  
- Contenedores: `chile-pg`, `etl`, `pgadmin`, `n8n`, `cloudflared`  
- Repositorio GitHub privado operando  
- Versión inicial del pipeline funcionando con datos septiembre 2024  

---

## 8. Requisitos funcionales

- Capacidad de procesar nuevos meses sin reescritura del pipeline.
- Logs automáticos y reproducibles.
- Validaciones de calidad (DQ).
- Entradas y salidas definidas (schema contract).

---

## 9. Requisitos no funcionales

- Reproducibilidad total en cualquier máquina con Docker.
- Versionado completo vía Git.
- Escalabilidad conceptual (pipeline modular).
- Documentación obligatoria.

---

## 10. Evaluación y criterios de éxito

| Criterio                              |          Método de validación |
|---------------------------------------|-------------------------------|
| Pipeline ejecutable end-to-end        | `docker compose up`           |
| Datos limpios + cargados en Postgres  | Scripts de validación + SQL   |
| KPIs calculados y visibles            | Dashboard                     |
| Orquestación funcionando              | Flujo n8n                     |
| Documentación acorde a guía UCM       | Entrega final validada        |

---

## 11. Riesgos y mitigaciones

| Riesgo                            | Mitigación                                   |
|-----------------------------------|----------------------------------------------|
| Sobredimensionar el alcance       | Mantener alcance IN/OUT fijo                 |
| Complejidad de integración LP-OC  | Documentar parcialidad como decisión técnica |
| Dependencia API                   | Datos ya descargados aseguran continuidad    |
| Deriva hacia análisis legal       | Enfoque 100% técnico                         |

---

## 12. Estado actual (línea base)

✔ Infraestructura creada  
✔ Repositorio GitHub operativo  
✔ ETL inicial funcionando (septiembre 2024)  
⚠ Falta generación completa de pipeline mensual  
⚠ Falta dashboard final  
⚠ Falta documentación oficial (en progreso)

---

## Próximo entregable

📌 **Roadmap detallado basado en este Scoping (versión 1.0).**

---

### 2026-01-20 Aclaración metodológica sobre la automatización

La automatización de cargas periódicas forma parte del alcance del proyecto.
No obstante, esta automatización se encuentra subordinada a un proceso previo
de evaluación de calidad de datos por período.

El proyecto prioriza la integridad analítica del Data Warehouse por sobre la
ejecución automática de procesos, incorporando mecanismos explícitos para
decidir cuándo una carga debe ejecutarse y cuándo debe ser omitida (NO-OP).

Este enfoque no reduce el alcance del TFM, sino que lo fortalece desde una
perspectiva metodológica y profesional.

---

### Fuentes de datos y restricciones de acceso

El proyecto contempla la ingestión de datos estructurados del sistema ChileCompra
(Licitaciones y Órdenes de Compra) a través de dos mecanismos:

1. **Descarga manual de archivos mensuales (CSV/XLSX)**, utilizada como
   fuente operativa principal del TFM.
2. **Consumo vía API oficial de ChileCompra**, considerado como extensión futura
   del pipeline.

El acceso a la API oficial de ChileCompra requiere la entrega de credenciales
(tickets de acceso) por parte del proveedor. Durante el desarrollo del TFM,
dichas credenciales fueron solicitadas formalmente, sin obtener respuesta
dentro del período de ejecución del proyecto.

En consecuencia, el alcance operativo validado del TFM se basa en el procesamiento
de archivos mensuales descargados manualmente, lo cual no compromete los objetivos
académicos del proyecto ni su reproducibilidad.

---
