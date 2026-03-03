# README_TRAZABILIDAD_INDEX.md

## Índice rápido — Auditoría BI (Fase 7)

Este documento actúa como índice rápido para navegar la evidencia final de trazabilidad
DW → DAX → KPI → Dashboard.

---

### 1. Artefactos oficiales de trazabilidad BI (carpeta actual)

| Artefacto             | Archivo                                               | Descripción                            |
|-----------------------|-------------------------------------------------------|----------------------------------------|
| Matriz maestra        | `MATRIZ_TRAZABILIDAD_DW_DAX_KPI_FINAL_CON_DT_OK.xlsx` | Matriz final KPI→DAX→Fuente→SQL→Estado |
| SQL contraste         | `SQL_CONTRASTE_KPIS_FASE7.sql`                        | SQL reproducible por KPI y moneda      |
| Resultados SQL        | `RESULTADOS_SQL_KPIS_CLP.csv`                         | Output real de ejecución SQL           |
| Hallazgos             | `HALLAZGOS_AUDITORIA_BI.md`                           | Diferencias, limitaciones y conclusión |
| Consolidado Gate BI-1 | `CONSOLIDADO_GATE_BI1_LIC_OC.xlsx`                    | Resumen de coherencia numérica LIC/OC  |

---

### 2. Evidencia del modelo Power BI (anexo técnico)

📌 Carpeta: `ANEXOS_MODELO_PBI/`

| Archivo                             | Descripción                               |
|-------------------------------------|-------------------------------------------|
| `PBI_model_summary.json`            | Resumen del modelo exportado              |
| `PBI_model_tables_inventory.csv`    | Inventario de tablas del modelo           |
| `PBI_model_partitions_sources.csv`  | Evidencia de fuentes (CSV vs PostgreSQL)  |
| `PBI_model_relationships.csv`       | Relaciones del modelo semántico           |
| `PBI_model_measures.csv`            | Medidas DAX extraídas desde `model.bim`   |
| `README_ANEXOS_MODELO_PBI.md`       | Explicación del anexo técnico             |

---

### 3. Evidencia por dashboard (carpeta hermana)

📌 Carpeta raíz: `../Coherencia_numerica_DW_vs_BI/`

Nota: las rutas relativas asumen ejecución desde la carpeta `Trazabilidad/`.

#### LIC

Ruta:
`../Coherencia_numerica_DW_vs_BI/LIC/`

Contiene:

- notebook evidencia: `LIC_Evidencia_BI_vs_SQL_v9.ipynb`
- outputs BI vs SQL: `outputs/lic_kpis_bi_vs_sql.csv`
- log SQL: `outputs/lic_kpis_sql.log`

Validación aplicada:

- Gate BI-1 (Power BI vs SQL DW)

---

#### OC

Ruta:
`../Coherencia_numerica_DW_vs_BI/OC/`

Contiene:

- notebook evidencia: `OC_Evidencia_BI_vs_SQL_v4.ipynb`
- outputs BI vs SQL: `outputs/oc_kpis_bi_vs_sql.csv`
- log SQL: `outputs/oc_kpis_sql.log`

Validación aplicada:

- Gate BI-1 (Power BI vs SQL DW)

---

#### DT_TEND / DT_SECT

Ruta:
`../Coherencia_numerica_DW_vs_BI/DT_TEND_y_DT_SECT/`

Contiene:

- notebook evidencia: `Evidencia_DT_TEND_DT_SECT_v4.ipynb`
- outputs CSV consumidos por BI: `outputs/02_Cruce/D6_*.csv`
- mapa trazabilidad CSV→Notebook: `trace_csv_notebook_map.xlsx`

Validación aplicada:

- Gate CSV (DW→Notebook→CSV→Power BI)

Limitación declarada:

- Gate CSV confirmado; comparación numérica final Power BI visual vs CSV: **NO CONSTA**.

---

#### RECON

Ruta:
`../Coherencia_numerica_DW_vs_BI/RECON/`

Contiene:

- notebook evidencia: `RECON_Evidencia_BI_vs_SQL_v6.ipynb`
- outputs BI vs SQL: `outputs/recon_kpis_bi_vs_sql.csv`
- log SQL: `outputs/recon_kpis_sql.log`

Validación aplicada:

- Gate BI-1 (Power BI vs SQL DW)

---

## 4. Documento maestro de metodología

📌 Documento oficial:
`README_AUDITORIA_TRAZABILIDAD_BI.md`

Este archivo explica el procedimiento completo y define los criterios de aceptación.

---

## 5. Ejecución rápida (comando de contraste SQL)

Ejemplo para CLP:

```bash
cd "TFM/docs/evidence/fase7_AuditoriaBI/Trazabilidad"

docker exec -i tfm-chile-pg-1 psql -U chile_user -d chilecompra \
  -v moneda_norm="'CLP'" \
  < SQL_CONTRASTE_KPIS_FASE7.sql
```

---

## 6. Criterio de lectura para verificación de trazabilidad

Se recomienda revisar solo 3 archivos para verificación de trazabilidad, deben ser:

1. `README_AUDITORIA_TRAZABILIDAD_BI.md`
2. `MATRIZ_TRAZABILIDAD_DW_DAX_KPI_FINAL_CON_DT_OK.xlsx`
3. `HALLAZGOS_AUDITORIA_BI.md`
