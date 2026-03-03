# Auditoría Numérica — Coherencia DW vs BI/CSV (Fase 7)

**Fase:** Fase 7 — Auditoría  Coherencia numérica
**Bloque Maestro:** CHAT 3 — Coherencia numérica DW vs CSV  
**Fecha de cierre:** 11-02-2026  
**Versión Power BI auditada:** `v5`  
**Modelo BI:** `TFM_ReneJara_ChileCompra_FaseBI_PowerBI_2024-09_2025-10_v5`

---

## 1. Objetivo del documento

Este README documenta la auditoría de **coherencia numérica** entre:

- Valores mostrados en **Power BI** (KPIs visibles en dashboards),
- Resultados obtenidos mediante **consultas SQL reproducibles** sobre el Data Warehouse,
- Outputs generados por notebooks (CSV diagnósticos) cuando aplica.

El propósito es demostrar formalmente ante tribunal que:

✅ El modelo BI no “inventa” KPIs  
✅ Los valores reportados en Power BI son consistentes con la capa semántica DW (`dw_sem`)  
✅ Los CSV utilizados en dashboards diagnósticos corresponden a evidencia reproducible controlada

---

## 2. Principio metodológico (contrato DW vs CSV)

### 2.1 Fuente oficial de verdad

La fuente oficial del modelo analítico es el **Data Warehouse en PostgreSQL**, específicamente la capa semántica:

- `dw_sem.*`

En particular, se utilizaron vistas rectoras como:

- `dw_sem.v_fact_licitaciones_sem_v2`
- `dw_sem.v_fact_ordenes_compra_sem_v2`

---

### 2.2 Rol de los CSV

Los CSV consumidos por Power BI (principalmente en DT_TEND / DT_SECT) no se consideran fuente oficial de negocio, sino:

- outputs reproducibles generados por notebooks,
- datasets diagnósticos y de control,
- evidencia técnica para trazabilidad del cruce LIC–OC.

📌 En consecuencia:

- Dashboards analíticos principales deben validar coherencia BI ↔ SQL.
- Dashboards diagnósticos pueden validar coherencia BI ↔ CSV (si corresponde).

---

## 3. Regla crítica transversal: moneda_norm

Esta auditoría se ejecuta bajo el principio metodológico obligatorio:

> No se comparan montos entre monedas distintas.

Por tanto:

- los KPIs monetarios se validan respetando `moneda_norm`,
- los resultados se auditan por moneda o con slicer aplicado,
- no se realizan conversiones CLP↔USD↔EUR↔UTM↔CLF.

📌 Esto es esencial para evitar conclusiones inválidas ante tribunal.

---

## 4. Dashboards existentes en el modelo BI

Listado total de páginas del reporte Power BI:

- MENU  
- INFO  
- LIC  
- LIC_EST  
- CRUCE_COD  
- NO_CRUCE  
- DT_TEND  
- DT_SECT  
- OC  
- HALLAZGOS  
- RECON  

---

## 5. Dashboards auditados numéricamente (alcance efectivo)

Dashboards auditados bajo criterio de coherencia numérica:

- **LIC**
- **OC**
- **DT_TEND y DT_SECT**
- **RECON**

Estos dashboards cuentan con evidencia reproducible mediante:

- notebook ejecutable
- outputs CSV
- log SQL
- comparativo BI vs SQL/CSV
- README con dictamen final

---

## 6. Dashboards fuera de alcance por redundancia o no materialidad

### 6.1 LIC_EST (redundancia)

No se audita individualmente por ser una vista derivada del dashboard LIC, reutilizando:

- mismas tablas semánticas
- mismas medidas base
- misma lógica de filtrado

📌 Su coherencia queda cubierta por la auditoría madre LIC y por auditorías transversales del modelo.

---

### 6.2 CRUCE_COD (dashboard exploratorio auxiliar)

No se audita con comparación numérica completa debido a que corresponde a un dashboard auxiliar de cruce.

📌 No constituye evidencia principal del modelo BI y su coherencia queda cubierta por:

- auditoría de DT_TEND / DT_SECT (dashboards derivados)
- auditorías transversales de filtros y modelo tabular

---

### 6.3 NO_CRUCE (no aplica auditoría numérica)

NO_CRUCE cumple una función metodológica y declarativa.

No contiene KPIs cuantitativos auditables, por tanto:

- no aplica comparación BI ↔ SQL
- su validación es únicamente narrativa (existencia, visibilidad y coherencia metodológica)

---

## 7. Dashboards donde no aplica auditoría numérica

Dashboards no auditables bajo enfoque numérico por diseño:

- MENU
- INFO
- HALLAZGOS

Motivo: son páginas documentales / navegación / narrativa.

---

## 8. Artefactos utilizados en la auditoría

Esta auditoría se apoya en tres insumos oficiales del modelo BI:

### 8.1 Export de medidas DAX

📄 `v5_medidas_dax_ver5.0.tsv`

Usado para:

- validar la capa de cálculo
- detectar medidas redundantes o inconsistentes
- revisar uso de filtros (ALL, REMOVEFILTERS, CALCULATE)

---

### 8.2 Export de modelo tabular Power BI

📦 `v5_Report+SemanticModel.zip`

Usado para:

- validar estructura estrella real
- verificar cardinalidades 1:*
- confirmar relaciones activas/inactivas
- confirmar separación DW vs CSV

---

### 8.3 Documento académico del TFM

📘 `v5_TFM_ReneJara_ChileCompra_FaseBI_PowerBI_2024-09_2025-10_v5.pdf`

Usado para:

- validar coherencia entre narrativa y modelo implementado
- asegurar alineación metodológica CLEAN→STG→DW→BI

---

## 9. Estructura oficial de evidencia (repositorio)

La auditoría numérica se documenta mediante la siguiente estructura estandarizada:

```text
Coherencia_numerica_DW_vs_BI/
├── LIC/
│ ├── LIC_Evidencia_BI_vs_SQL_v9.ipynb
│ ├── README_LIC.md
│ └── outputs/
│ ├── lic_kpis_bi.csv
│ ├── lic_kpis_bi_vs_sql.csv
│ ├── lic_kpis_sql.csv
│ └── lic_kpis_sql.log
│
├── OC/
│ ├── OC_Evidencia_BI_vs_SQL_v4.ipynb
│ ├── README_OC.md
│ └── outputs/
│ ├── oc_kpis_bi.csv
│ ├── oc_kpis_bi_vs_sql.csv
│ ├── oc_kpis_sql.csv
│ └── oc_kpis_sql.log
│
├── DT_TEND_y_DT_SECT/
│ ├── Evidencia_DT_TEND_DT_SECT_v4.ipynb
│ ├── README_DT_TEND_DT_SECT.md
│ ├── trace_csv_notebook_map.xlsx
│ └── outputs/
│ └── 02_Cruce/
│ ├── D6_alerta_moneda_oferta.csv
│ ├── D6_control_meses_lic.csv
│ ├── D6_control_meses_oc.csv
│ ├── D6_cruces_sector_moneda.csv
│ ├── D6_dist_lic_por_oc.csv
│ ├── D6_dist_oc_por_lic.csv
│ ├── D6_kpi_resumen.csv
│ ├── D6_moneda_mapeo_std.csv
│ ├── D6_oc_con_sin_lic_por_mes.csv
│ └── D6_trend_por_mes.csv
│
└── RECON/
├── README_RECON.md
├── RECON_Evidencia_BI_vs_SQL_v6.ipynb
└── outputs/
├── recon_bi_vs_sql_csv.xlsx
├── recon_kpis_bi_template.csv
├── recon_kpis_bi_vs_sql.csv
├── recon_kpis_sql.csv
└── recon_kpis_sql.log
```

📌 Esta estructura garantiza:

- replicabilidad por dashboard
- evidencia autocontenida
- separación de outputs vs lógica
- trazabilidad tribunal-proof

---

## 10. Metodología operativa aplicada (protocolo estándar)

La auditoría numérica se ejecuta bajo un protocolo replicable por dashboard:

### Paso 1 — Extracción de valores BI

Se capturan valores de KPIs visibles en Power BI (tarjetas/tablas).

Salida:

- `<dashboard>_kpis_bi.csv`

---

### Paso 2 — Extracción SQL reproducible desde DW_SEM

Se ejecutan queries SQL directamente sobre `dw_sem.*`.

Salidas:

- `<dashboard>_kpis_sql.csv`
- `<dashboard>_kpis_sql.log`

El log es obligatorio para demostrar reproducibilidad.

---

### Paso 3 — Comparación BI vs SQL

Se cruza el valor BI contra el valor SQL.

Salida:

- `<dashboard>_kpis_bi_vs_sql.csv`

Incluye columnas estándar:

- `valor_pbi_str`
- `valor_sql_str`
- `diff_abs_str`
- `diff_pct_str`
- `estado`

---

### Paso 4 — Dictamen final

Cada dashboard auditado debe declarar explícitamente:

- KPIs validados
- fuente oficial (vista DW)
- outputs utilizados
- resultado final (OK / NO_OK)

📌 Regla clave: el tribunal valida texto, no notebooks.

---

## 11. Hallazgos críticos detectados y resueltos

### 11.1 Riesgo de inconsistencia por moneda (mitigado)

Se detectó que una auditoría global sin segmentación por moneda produciría incoherencias artificiales.

✅ Mitigación aplicada:

- auditoría por `moneda_norm`
- KPIs monetarios auditados con slicer aplicado o grain moneda

---

### 11.2 Riesgo semántico en LIC (UTM vs “Moneda revisar”) — Resuelto

Se detectó inconsistencia en categorización monetaria en LIC:

- registros rotulados como “UTM” no correspondían a una moneda real consistente en DW

✅ Resolución:

- se identificó y documentó que esos registros corresponden a “Moneda revisar”
- se dejó explícito como hallazgo corregido para evitar preguntas de tribunal

---

### 11.3 Riesgo tribunal: dashboards sin evidencia KPI vs SQL — Resuelto

Se identificó que DT_TEND / DT_SECT inicialmente solo contaban con outputs auxiliares, pero sin comparativo BI vs evidencia.

✅ Resolución:

- se completó README + outputs + trazabilidad
- se consolidó la estructura al estándar LIC/OC

---

### 11.4 Riesgo de auditoría incompleta (OC y RECON) — Resuelto

Se detectó que sin dictamen escrito explícito, un dashboard “no existe” ante tribunal aunque tenga outputs.

✅ Resolución:

- se consolidaron outputs finales
- se incorporó regla de cierre explícita (NO_OK=0, FALTA_PBI=0, FALTA_SQL=0)

---

## 12. Criterio formal de cierre (regla de auditoría)

Un dashboard se considera auditado y cerrado si:

- `NO_OK = 0`
- `FALTA_PBI = 0`
- `FALTA_SQL = 0`

Tolerancias aplicadas:

- Conteos: tolerancia absoluta = **0**
- Montos: tolerancia absoluta ≤ **1 unidad** (redondeos/formato)

📌 Esta regla aplica especialmente en RECON como Gate BI-1.

---

## 13. Resultado de auditoría por dashboard (dictamen ejecutivo)

### LIC

Estado: ✅ **CERRADO / SELLADO / DEFENDIBLE**

- coherencia numérica completa BI vs SQL
- fuente oficial: `dw_sem.v_fact_licitaciones_sem_v2`
- hallazgo monetario detectado y corregido (“UTM” → “Moneda revisar”)

---

### OC

Estado: ✅ **CERRADO / VALIDADO**

- coherencia numérica completa BI vs SQL
- fuente oficial: `dw_sem.v_fact_ordenes_compra_sem_v2`
- evidencia completa: BI csv + SQL csv + SQL log + comparativo final

---

### DT_TEND / DT_SECT

Estado: ✅ **CERRADO**

- dashboards diagnósticos con evidencia reproducible
- outputs controlados en `outputs/02_Cruce/`
- trazabilidad formal en `trace_csv_notebook_map.xlsx`
- consistencia documental alineada al estándar tribunal-proof

---

### RECON (Gate BI-1)

Estado: ✅ **CERRADO / EVIDENCIA PRINCIPAL**

- dashboard técnico de control
- valida coherencia numérica DW → BI
- auditoría por moneda_norm para demostrar comportamiento del slicer
- evidencia principal:
  - `recon_kpis_bi_vs_sql.csv`
  - `recon_kpis_sql.log`

---

## 14. Consideraciones metodológicas obligatorias (para tribunal)

Esta auditoría declara explícitamente:

- No se realizan conversiones de moneda.
- Los montos no son comparables entre monedas.
- El cruce LIC–OC es exploratorio y está sujeto a limitaciones estructurales.
- Los dashboards auxiliares no constituyen evidencia principal si no contienen KPIs auditables.
- El estándar de auditoría es reproducible sin depender de Power BI GUI.

---

## 15. Conclusión global

Con base en notebooks ejecutables, outputs CSV generados y logs SQL reproducibles, se concluye:

✅ Existe coherencia numérica completa entre Power BI y el Data Warehouse semántico (`dw_sem`) para los dashboards auditados.

No se detectan discrepancias estructurales que invaliden el modelo BI.

📌 La auditoría numérica se considera formalmente cerrada y defendible ante tribunal bajo el estándar:

**Notebook + outputs + SQL log + comparativo + dictamen escrito.**

---

## 16. Estado final

**AUDITORÍA — COHERENCIA NUMÉRICA DW vs BI:**  
**CERRADA / OK ✅**

---
