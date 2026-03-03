# HALLAZGOS_AUDITORIA_BI (Fase 7)

## 1. Alcance y evidencia usada

Esta auditoría consolida evidencia reproducible de coherencia numérica y trazabilidad:

DW → (SQL / Notebook / CSV) → Modelo Power BI → KPI → Dashboard.

Fuentes de evidencia utilizadas:

- LIC: `outputs/lic_kpis_bi_vs_sql.csv`
- OC: `outputs/oc_kpis_bi_vs_sql.csv`
- DT_TEND/DT_SECT: `outputs/02_Cruce/D6_kpi_resumen.csv` (outputs notebook consumidos por Power BI)
- RECON: `outputs/recon_kpis_bi_vs_sql.csv`

Nota: las rutas `outputs/...` refieren a la carpeta de cada dashboard dentro de:

`../Coherencia_numerica_DW_vs_BI/{DASHBOARD}/outputs/`

---

## 2. Hallazgos por dashboard

### 2.1 LIC — Gate BI-1 (Power BI vs SQL DW)

- KPIs evaluados: **28**
- OK: **25**
- NO_APLICA: **3**
- DIF: **0**

No se detectan KPIs con estado **DIF** en la evidencia aportada.

---

### 2.2 OC — Gate BI-1 (Power BI vs SQL DW)

- KPIs evaluados: **25**
- OK: **25**
- DIF: **0**

No se detectan KPIs con estado **DIF** en la evidencia aportada.

---

### 2.3 DT_TEND / DT_SECT — Gate CSV (DW → Notebook → CSV → Power BI)

- KPIs listados en `D6_kpi_resumen.csv` (según matriz): **7**
- Validación aplicada: **Gate CSV confirmado (DW → Notebook → CSV → Power BI)**
- Evidencia: el dashboard consume outputs CSV generados por notebook reproducible que consulta el DW.
- Gate CSV confirmado; comparación numérica final Power BI visual vs CSV: **NO CONSTA** (no se aportó export visual desde Power BI). Esto se declara como limitación formal del snapshot auditado.

Estado metodológico:

- La trazabilidad DW→Notebook→CSV→Power BI está confirmada.
- No consta export numérico desde Power BI (valores visuales), por lo que no fue posible ejecutar comparación numérica final (Power BI visual vs CSV fuente).
- Esta ausencia se declara como limitación formal del snapshot auditado, pero no invalida la trazabilidad confirmada por fuente.

---

### 2.4 RECON — Gate BI-1 (Power BI vs SQL DW)

- KPIs evaluados: **27**
- OK: **27**
- NO_APLICA: **0**
- DIF: **0**

No se detectan KPIs con estado **DIF** en la evidencia aportada.

---

## 3. Riesgos y limitaciones declaradas

- DT_TEND/DT_SECT:
  - No consta export visual desde Power BI (valores numéricos del dashboard).
  - Se valida mediante Gate CSV (consumo confirmado de outputs reproducibles).

- No se detectan diferencias numéricas (DIF) en dashboards validados por Gate BI-1 (LIC, OC, RECON) en el snapshot auditado.

---

## 4. Conclusión

Con la evidencia aportada:

- **LIC, OC y RECON** presentan trazabilidad completa y contraste numérico reproducible mediante Gate BI-1 (Power BI vs SQL DW).
- **DT_TEND/DT_SECT** presentan trazabilidad confirmada DW→Notebook→CSV→Power BI mediante Gate CSV.
- La comparación numérica final Power BI visual vs CSV fuente **NO CONSTA** y se declara como limitación formal del snapshot auditado.

En consecuencia, los dashboards auditados quedan respaldados por evidencia reproducible y documentada, sin hallazgos de diferencias numéricas en los KPIs contrastados mediante SQL.
