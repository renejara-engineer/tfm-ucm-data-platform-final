# README_AUDITORIA_TRAZABILIDAD_BI.md

## Fase 7 — Auditoría BI y Trazabilidad DW → DAX → KPI

### 1. Propósito del documento

Este documento describe la metodología y los artefactos generados en la **Fase 7 – Auditoría BI** del proyecto **ChileCompra Data Platform (TFM UCM)**.

El objetivo es demostrar trazabilidad completa y reproducible entre:

Data Warehouse (PostgreSQL DW) → (Power BI / DAX y/o Notebook → CSV) → KPI → Dashboard

La auditoría se orienta a evidencia verificable, evitando afirmaciones no sustentadas.

---

### 2. Contexto del proyecto

El TFM implementa una plataforma de datos local basada en:

- Docker Compose como infraestructura reproducible
- PostgreSQL 15 como Data Warehouse
- ETL modular en Python (contenedor ETL)
- Data Lake con capas RAW/CLEAN/MART/METADATA
- n8n como orquestador batch mensual
- Power BI como capa de consumo (evidencia descriptiva)

**Periodo cubierto:** 2024-09 → 2025-10 (según carga final válida del pipeline).

---

### 3. Regla metodológica crítica

**No se mezclan monedas.**  
CLP ≠ USD ≠ UF ≠ CLF ≠ EUR ≠ UTM

No se realizan conversiones ni agregaciones cruzadas entre monedas.

---

### 4. Motivación de la auditoría BI (control de calidad y trazabilidad)

En proyectos donde Power BI actúa como capa final de consumo, existe el riesgo de inconsistencias entre los valores mostrados en dashboards y los datos persistidos en el Data Warehouse, debido a:

- transformaciones no documentadas en Power Query,
- medidas DAX complejas o no inventariadas,
- filtros implícitos en visuales o relaciones del modelo semántico,
- diferencias de granularidad entre tablas de origen y agregaciones BI.

Por ello, esta auditoría genera evidencia formal y reproducible para asegurar que:

- las medidas DAX relevantes están definidas y documentadas,
- cada KPI está vinculado a una fuente verificable (DW o CSV generado por notebook),
- existen consultas SQL reproducibles para contraste numérico (Gate BI-1) cuando aplica,
- los hallazgos, supuestos y limitaciones quedan declarados explícitamente.

---

### 5. Estructura y artefactos oficiales (esta carpeta)

Esta carpeta Trazabilidad/ contiene las evidencias de la auditoria y fuentes utilizadas:

#### 5.1 Matriz maestra de trazabilidad

📌 `MATRIZ_TRAZABILIDAD_DW_DAX_KPI_FINAL_CON_DT_OK.xlsx`

Contiene para cada KPI:

- Dashboard asociado (LIC / OC / DT_TEND / DT_SECT / RECON)
- Medida DAX y fórmula
- Fuente (DW / CSV / derivada)
- Tabla/vista origen
- SQL contraste reproducible
- Resultado SQL
- Resultado BI (cuando consta)
- Estado (OK / DIF / NO CONSTA)
- Evidencia asociada (ruta)

---

#### 5.2 SQL de contraste reproducible

📌 `SQL_CONTRASTE_KPIS_FASE7.sql`

Script SQL diseñado para ejecutar consultas equivalentes a KPIs críticos
(segmentados por moneda).

---

#### 5.3 Resultados SQL ejecutados (evidencia)

📌 `RESULTADOS_SQL_KPIS_CLP.csv`

Resultados reales obtenidos desde PostgreSQL (ejecución reproducible).

**Nota metodológica:**
Este archivo contiene resultados ejecutados para moneda_norm = 'CLP' como evidencia prioritaria, ya que CLP representa la moneda principal de análisis en la plataforma. La auditoría es reproducible para otras monedas (USD, UF, CLF, EUR, UTM) ejecutando el mismo script SQL y parametrizando el filtro moneda_norm.

---

#### 5.4 Hallazgos consolidados de auditoría

📌 `HALLAZGOS_AUDITORIA_BI.md`

Documento de hallazgos y limitaciones (OK / DIF / NO CONSTA), incluyendo riesgos declarados y conclusiones basadas en evidencia.

---

#### 5.5 Evidencia estructural del modelo Power BI (modelo semántico)

📌 Carpeta `ANEXOS_MODELO_PBI/`

Incluye inventarios extraídos automáticamente desde `model.bim`:

- `PBI_model_tables_inventory.csv`
- `PBI_model_partitions_sources.csv`
- `PBI_model_relationships.csv`
- `PBI_model_measures.csv`
- `PBI_model_summary.json`

Este anexo permite demostrar que el modelo BI contiene:

- medidas DAX explícitas,
- tablas provenientes de PostgreSQL (DW),
- tablas provenientes de CSV (outputs notebook),
- relaciones explícitas del modelo.

---

### 6. Metodología aplicada (resumen reproducible)

#### Paso 0 — Alcance de auditoría

La auditoría se centra en KPIs core de los dashboards principales:

- LIC (Licitaciones)
- OC (Órdenes de Compra)
- DT_TEND / DT_SECT (Dashboards temáticos alimentados por CSV)

La hoja RECON se considera una hoja técnica de validación y conciliación. En este snapshot, RECON cuenta con evidencia de contraste numérico BI vs SQL disponible en ../Coherencia_numerica_DW_vs_BI/RECON/outputs/recon_kpis_bi_vs_sql.csv.

#### Paso 1 — Inventario de medidas DAX

Se extraen medidas del modelo Power BI mediante export del modelo (`model.bim`)
y/o inventario TSV de medidas.

Evidencia:

- `ANEXOS_MODELO_PBI/PBI_model_measures.csv`

---

#### Paso 2 — Inventario de fuentes (DW vs CSV)

Se revisan particiones Power Query para identificar fuentes reales del modelo.

Evidencia:

- `ANEXOS_MODELO_PBI/PBI_model_partitions_sources.csv`

---

#### Paso 3 — Selección KPIs core

Se seleccionan KPIs críticos (montos, conteos, distintos, cobertura).

Evidencia:

- Matriz final (`MATRIZ_TRAZABILIDAD...xlsx`)

---

#### Paso 4 — Construcción SQL equivalente (Gate BI-1)

Se definen consultas SQL reproducibles para cada KPI basado en DW.

Evidencia:

- `SQL_CONTRASTE_KPIS_FASE7.sql`

---

#### Paso 5 — Ejecución SQL en PostgreSQL

Ejemplo de ejecución reproducible:

```bash
docker exec -i tfm-chile-pg-1 psql -U chile_user -d chilecompra \
  -v moneda_norm="'CLP'" \
  < SQL_CONTRASTE_KPIS_FASE7.sql
```

---

#### Paso 6 — Comparación BI vs SQL (Gate BI-1)

Se comparan valores SQL vs valores reportados en Power BI.
Los dashboards **LIC, OC y RECON** se validan por Gate BI-1 numérico directo.

---

#### Paso 7 — Validación DT_TEND / DT_SECT por Gate CSV

DT_TEND y DT_SECT se validan mediante Gate CSV, confirmando reproducibilidad DW→Notebook→CSV y consumo desde Power BI.
Gate CSV confirmado; comparación numérica final Power BI visual vs CSV: NO CONSTA.

Flujo demostrado:

Data Warehouse (PostgreSQL DW) → Notebook → CSV → Modelo Semántico (Power BI / DAX) → KPI → Dashboard

Evidencia:

- carpeta `Coherencia_numerica_DW_vs_BI/DT_TEND_y_DT_SECT/`
- outputs `D6_*.csv`
- evidencia modelo: `ANEXOS_MODELO_PBI/PBI_model_partitions_sources.csv`

---

#### Paso 8 — Consolidación de hallazgos

Toda diferencia (DIF) o falta de evidencia (NO CONSTA) se documenta explícitamente.

Evidencia:

- `HALLAZGOS_AUDITORIA_BI.md`

---

### 7. Criterios de aceptación (auditoría)

Un KPI se considera:

- **OK**: trazabilidad confirmada y contraste numérico coherente (cuando aplica).
- **DIF**: existe diferencia entre SQL y BI, documentada en hallazgos.
- **NO CONSTA**: no existe evidencia suficiente para reproducir o validar el KPI.

La categoría NO CONSTA no implica error del KPI, sino ausencia de evidencia suficiente en el snapshot auditado para demostrar su reproducibilidad completa. En estos casos, el indicador se declara como limitación formal del modelo auditado.

Regla obligatoria:

- No se mezclan monedas.
- Validaciones siempre segmentadas por `moneda_norm`.

Definición adicional — Medida derivada: Se considera "medida derivada" aquella medida DAX que no se calcula directamente desde una tabla del DW o desde un CSV, sino que se construye a partir de otras medidas previamente trazadas (ej. porcentajes, ratios, diferencias, acumulados). La validación de una medida derivada se realiza verificando la trazabilidad completa de sus medidas base y su correcta composición lógica.

En estos dashboards, el CSV constituye la fuente oficial de cálculo, por lo que la validación se centra en la reproducibilidad DW→Notebook→CSV y en la confirmación de consumo desde Power BI (partitions_sources).

---

### 8. Limitaciones declaradas

- Algunos KPIs dependen de filtros de contexto del modelo semántico.
- DT_TEND/DT_SECT se validan por Gate CSV, no por Gate SQL directo.
- KPIs sin evidencia numérica o sin fuente explícita quedan como NO CONSTA.

---

### 9. Conclusión basada en evidencia

Con los artefactos de esta carpeta, es posible afirmar:

> “Los KPIs principales del reporte Power BI ChileCompra han sido auditados y son trazables
desde el Data Warehouse PostgreSQL hasta las medidas DAX y dashboards finales.  
Los indicadores LIC y OC han sido contrastados numéricamente mediante SQL reproducible
(Gate BI-1). Los dashboards DT_TEND y DT_SECT se alimentan de outputs CSV reproducibles
generados desde DW por notebooks, y su consumo BI está respaldado por evidencia del modelo
semántico exportado.”

La hoja RECON se valida como soporte técnico mediante contraste BI vs SQL según evidencia exportada.

---

### 10. Archivos oficiales finales en esta carpeta

- `README_AUDITORIA_TRAZABILIDAD_BI.md`
- `MATRIZ_TRAZABILIDAD_DW_DAX_KPI_FINAL_CON_DT_OK.xlsx`
- `SQL_CONTRASTE_KPIS_FASE7.sql`
- `RESULTADOS_SQL_KPIS_CLP.csv`
- `HALLAZGOS_AUDITORIA_BI.md`
- `ANEXOS_MODELO_PBI/`
- `CONSOLIDADO_GATE_BI1_LIC_OC.xlsx`
