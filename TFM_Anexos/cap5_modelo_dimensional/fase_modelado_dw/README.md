# Modelado Analítico y Gobierno del Data Warehouse

Este directorio contiene la documentación normativa que consolida el modelo analítico del proyecto ChileCompra Data Platform.

Representa el momento en que el Data Warehouse deja de ser únicamente una estructura técnica y pasa a constituir una base analítica formal, validada y gobernada.

Aquí se establecen:

- Decisiones arquitectónicas definitivas del modelo dimensional.
- Grano analítico oficial por dominio.
- Catálogo formal de KPIs.
- Criterios obligatorios de validación en SQL.
- Reglas de explotación en Power BI como capa probatoria.

---

## 1. Rol dentro del proyecto

Este conjunto documental:

- No redefine la arquitectura base.
- No modifica procesos ETL previos.
- No introduce transformaciones adicionales.
- No corrige datos en capas posteriores.

Su función es formalizar y proteger el modelo analítico antes de cualquier explotación visual.

Constituye el contrato técnico que garantiza:

- Coherencia entre negocio y modelo dimensional.
- Trazabilidad DW → SQL → BI.
- Reproducibilidad de métricas.
- Defensa académica ante evaluación externa.

---

## 2. Evolución implícita del proyecto

El proyecto transitó desde:

- una etapa exploratoria inicial basada en procesamiento tipo RAW–CLEAN–MART,
- hacia un Data Warehouse relacional gobernado por periodo,
- y finalmente hacia una explotación analítica controlada.

Este directorio corresponde a la etapa en que se consolidan:

- reglas,
- límites,
- validaciones,
- y definiciones formales del modelo.

---

## 3. Orden recomendado de lectura

> Precondición recomendada: revisar `arquitectura/Estado_oficial_pipeline_dw.md` para conocer el estado consolidado vigente del pipeline antes de interpretar este módulo.

1. `01_mapa_impacto_implementacion_fase5.md`
2. `02_metodologia_gates_fase5.md`
3. `03_decisiones_arquitectonicas_gate3.md`
4. `04_modelo_analitico_kpis.md`
5. `05_criterios_validacion_analitica.md`
6. `modelo_semantico_bi_powerbi_FINAL.md`
7. `00_continuidad_tecnica_gate3.md` (registro histórico)

---

## 4. Principio rector

Ninguna métrica puede visualizarse si no:

- respeta el grano definido,
- supera los criterios de validación,
- y es reproducible en SQL desde el Data Warehouse.

Power BI constituye una capa de evidencia, no de corrección.

---

## 5. Estado documental

Estos documentos se consideran congelados.

Cualquier modificación debe registrarse explícitamente en el log del proyecto y justificarse técnicamente.

---
