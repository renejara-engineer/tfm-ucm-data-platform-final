# OC — Auditoría BI vs SQL (Evidencia reproducible)

Este paquete valida **coherencia numérica** entre KPIs del dashboard **OC** (Power BI ) y resultados SQL ejecutados sobre **PostgreSQL / DW_SEM**.

> Criterio (alineado a los chats previos): **OC no tiene KPIs “globales”** (sin segmentación de moneda).  
> La auditoría compara **solo KPIs por moneda** (según slicer Moneda del dashboard).

---

## 1) Estructura esperada del directorio

OC/
├── OC_Evidencia_BI_vs_SQL_v4.ipynb
├── README_OC.md
└── outputs/
    ├── oc_kpis_sql.csv
    ├── oc_kpis_sql.log
    ├── oc_kpis_bi.csv
    └── oc_kpis_bi_vs_sql.csv

---

## 2) Fuente de datos (SQL)

- **Vista:** `dw_sem.v_fact_ordenes_compra_sem_v2`
- **Motor:** PostgreSQL (stack Docker)
- **Moneda auditada:** por defecto usa `moneda` (configurable a `moneda_norm` vía `MONEDA_FIELD`)

---

## 3) Estructura de outputs (evidencia reproducible)

Los archivos generados por este notebook quedan almacenados en:

`docs/evidence/fase7_auditoria_BI/Evidencia_BI_vs_SQL/OC/outputs/`

Contenido:

- `oc_kpis_sql.csv` → KPIs calculados vía SQL sobre DW_SEM
- `oc_kpis_sql.log` → log reproducible de consulta y diagnóstico de moneda
- `oc_kpis_bi.csv` → valores extraídos manualmente desde tarjetas Power BI
- `oc_kpis_bi_vs_sql.csv` → comparación final BI vs SQL (diff_abs, diff_pct, estado)

---

### Nota metodológica: KPIs OC sin globales

El dashboard **OC** no utiliza tarjetas globales (sin filtro de moneda).  
Todos los KPIs se interpretan **en el contexto del slicer de moneda**, por lo cual la validación se ejecuta exclusivamente por moneda (`CLP`, `USD`, `EUR`, `CLF`, `UTM`).

Esto es consistente con el diseño BI del proyecto, donde no se permite comparar montos entre monedas.

---

### Criterio de cálculo de montos (anti-doble conteo)

El monto total por moneda se calcula como SUM(MAX(monto_total)) por OC, agrupando por orden_compra_sk (preferente) o orden_compra_bk (fallback si no existe SK), para evitar doble conteo cuando la vista semántica contiene múltiples filas por OC.

---

### Tolerancia aplicada (precisión numérica)

Para KPIs de monto se aplica una tolerancia absoluta de:

- `TOL_MONTO_ABS = 1.0`

Esto se debe a diferencias menores de precisión entre el motor numérico de PostgreSQL y el motor de agregación de Power BI.

---

### Resultado final de auditoría (dictamen)

El archivo `oc_kpis_bi_vs_sql.csv` confirma:

- Todas las monedas evaluadas presentan estado **OK**
- Todas las métricas auditadas coinciden entre SQL (DW_SEM) y Power BI

📌 Dictamen técnico: **AUDITORÍA OC = OK**

---

## 4) Outputs (qué es cada archivo)

- `outputs/oc_kpis_sql.csv`  
  KPIs calculados en SQL (formato largo: `kpi, moneda_val, valor_sql`).

- `outputs/oc_kpis_sql.log`  
  Log de ejecución: vista usada, `MONEDA_FIELD`, diagnóstico (si aplica) y tabla SQL generada.

- `outputs/oc_kpis_bi.csv`  
  Valores capturados manualmente desde Power BI (tarjetas por moneda).  
  Si no existe, el notebook crea una **plantilla**.

- `outputs/oc_kpis_bi_vs_sql.csv`  
  Comparación final (merge SQL vs BI) con métricas de diferencia y estado.

---

## 5) Cómo ejecutar (paso a paso)

1) **Abrir el notebook**:
   - `OC_Evidencia_BI_vs_SQL_v4.ipynb`

2) **Configurar conexión** (recomendado por variables de entorno):
   - `PG_HOST` (default: `localhost`)
   - `PG_PORT` (default: `5433`)
   - `PG_DB`   (default: `chilecompra`)
   - `PG_USER` (default: `chile_user`)
   - `PG_PASS` (recomendado setear por env var)

3) **Ejecutar secciones**:
   - Generación SQL (`oc_kpis_sql.csv` + `oc_kpis_sql.log`)
   - Carga BI (`oc_kpis_bi.csv`)
   - Comparación (`oc_kpis_bi_vs_sql.csv`)

---

## 6) Criterio de aceptación

La auditoría se considera **OK** si:

- `oc_kpis_bi_vs_sql.csv` tiene `estado = OK` para todas las filas comparadas.
- Se acepta tolerancia numérica en montos por precisión float:
  - `TOL_MONTO_ABS = 1.0` (si `diff_abs <= 1`, se considera OK)

Además:

- Manejo explícito de caso `SQL=0` (`NO_OK_SQL0` si BI != 0).

---

## 7) Coherencia observada (resultado actual)

✅ Los archivos son coherentes entre sí:

- `oc_kpis_sql.csv` ↔ `oc_kpis_bi.csv` tienen las mismas combinaciones (`5 KPIs x 5 monedas = 25 filas`).
- `oc_kpis_bi_vs_sql.csv` reporta **25/25 en estado OK** (incluye UTM).
- La diferencia de monto CLP (~0.0195) es **ruido de precisión** y queda neutralizada por `TOL_MONTO_ABS`.

---

## 8) Nota técnica (mejora opcional)

Actualmente los flags DQ (`flag_moneda_missing`, `flag_moneda_unknown`) se aplican explícitamente en el cálculo de **monto** (evitar doble conteo + filtros).  
Si quieres blindar al máximo, puedes aplicar el mismo filtro DQ a los KPIs de conteo/distintos (no es necesario si ya coincide con BI, pero deja el contrato más sólido).

---

## 9) Historial

- Notebook: `OC_Evidencia_BI_vs_SQL_v4.ipynb`
- Evidencia generada en `outputs/` (CSV + LOG)
