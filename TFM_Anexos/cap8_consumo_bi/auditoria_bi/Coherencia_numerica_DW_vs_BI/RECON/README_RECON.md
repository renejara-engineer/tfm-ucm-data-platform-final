# RECON — Evidencia BI vs SQL (Auditoría Fase 7)

## 1. Propósito (rol del dashboard)

**RECON** es un panel **técnico de control** (Gate / validación inicial) cuyo objetivo es **verificar coherencia numérica** entre:

- **Power BI (tarjetas + totales de tabla)** en el dashboard RECON, y
- **PostgreSQL (DW)** consultando vistas semánticas `dw_sem`.

> RECON **no** es un dashboard analítico de negocio.  
> Es un artefacto documental para demostrar consistencia y trazabilidad DW → BI ante tribunal.

---

## 2. Regla clave: moneda_norm (por qué se audita “por moneda”)

En RECON existe slicer **`moneda_norm`** (CLP, USD, EUR, CLF, UTM).

- En Power BI: **solo se selecciona 1 moneda a la vez**.
- En SQL (auditoría): se calcula el KPI **agrupado por moneda_norm** para generar evidencia **fila a fila** (5 filas = 5 monedas).

✅ Por eso la auditoría incluye KPIs con `grain = moneda`:
no porque Power BI muestre todas juntas, sino porque se valida el comportamiento del slicer contra DW.

---

## 3. Alcance (KPIs auditados)

KPIs del contrato RECON (y fuente SQL espejo):

### 3.1 KPI global (no depende de moneda_norm)

- **LIC_Conteo**  
  Fuente: `dw_sem.v_fact_licitaciones_sem_v2`

### 3.2 KPIs por moneda_norm (depende del slicer)

- **OC_Conteo_etiqueta** (tarjeta “OC Conteo”)  
  Fuente: `dw_sem.v_fact_ordenes_compra_sem_v2` (group by moneda_norm)

- **OC_Monto_Total_etiqueta** (tarjeta “OC Monto Total”)  
  Fuente: `dw_sem.v_fact_ordenes_compra_sem_v2` (sum monto_total, group by moneda_norm)

- **OC_Monto_Total_fecha_aceptacion_valida** (tarjeta “OC Monto Total (Fecha Aceptación válida)”)  
  Fuente: `dw_sem.v_fact_ordenes_compra_sem_v2` con `fecha_aceptacion_sk IS NOT NULL` (group by moneda_norm)

> El notebook también puede incluir KPIs de referencia adicionales (ej. conteo global OC o montos “tabla”).
> Se consideran parte del set auditado **solo si están presentes en el CSV de comparación final**.

---

## 4. Evidencia generada (archivos) y relación entre ellos

### 4.1 Evidencia SQL (fuente oficial)

- `outputs/recon_kpis_sql.log`  
  Log con timestamp + SQL ejecutado + resultados (evidencia forense).
- `outputs/recon_kpis_sql.csv`  
  Resultados SQL tabulados (insumo de comparación).

### 4.2 Evidencia BI (valores observados en Power BI)

- `outputs/recon_kpis_bi_template.csv`  
  Archivo para pegar valores del dashboard RECON.
  - Para `grain=global`: `moneda_norm` vacío
  - Para `grain=moneda`: una fila por cada moneda (CLP, USD, EUR, CLF, UTM)

Recomendación de forma (opcional): mantener

- `recon_kpis_bi_template.csv` (vacío) y
- `recon_kpis_bi.csv` (completado),

> pero no es obligatorio si el notebook está leyendo correctamente el archivo completado.

### 4.3 Comparación BI vs SQL (dictamen)

- `outputs/recon_kpis_bi_vs_sql.csv`  
  Resultado comparado (BI vs SQL) con columnas:
  `valor_pbi_str`, `valor_sql_str`, `diff_abs_str`, `diff_pct_str`, `estado`
- `outputs/recon_bi_vs_sql_csv.xlsx`  
  Excel con 3 hojas: `SQL`, `BI`, `COMP` (formato presentable).

---

## 5. Notebook reproducible

- `RECON_Evidencia_BI_vs_SQL_v6.ipynb`

### 5.1 Requisitos

Variables de entorno (local):

- `PGHOST`, `PGPORT`, `PGDATABASE`, `PGUSER`, `PGPASSWORD`

Dependencias:

- `sqlalchemy`, `psycopg2-binary`, `pandas`, `openpyxl` (opcional), `python-dotenv` (opcional)

### 5.2 Ejecución (pasos)

1) Ejecutar el notebook (sección SQL) → genera `recon_kpis_sql.*`
2) Completar archivo BI (`recon_kpis_bi_template.csv`) pegando valores del dashboard:
   - Seleccionar `moneda_norm = CLP` y copiar tarjetas
   - Repetir para `USD`, `EUR`, `CLF`, `UTM`
3) Re-ejecutar sección comparación → genera `recon_kpis_bi_vs_sql.csv` + `recon_bi_vs_sql_csv.xlsx`

---

## 6. Regla de aceptación (cierre de auditoría)

La auditoría RECON se considera **CERRADA** si en `recon_kpis_bi_vs_sql.csv`:

- No existe `NO_OK`
- No existe `FALTA_PBI`
- No existe `FALTA_SQL`
- (Montos) tolerancia absoluta aplicada por casting/redondeo: **<= 1 unidad**
- (Conteos) igualdad exacta: **0 diferencia**

---

## 7. Dictamen final

✅ **DICTAMEN: Auditoría RECON CERRADA (BI vs SQL)**  
Criterio: el archivo `recon_kpis_bi_vs_sql.csv` de la corrida actual presenta **estado `OK` en todas las filas**.

---

## 8. Observaciones menores (no bloqueantes)

- Si en la exportación aparecen números en notación científica (ej. `4.633081e+06`),
  es solo un tema de presentación. La comparación se ejecuta con conversión segura a `Decimal`
  y el dictamen se mantiene válido.

---
