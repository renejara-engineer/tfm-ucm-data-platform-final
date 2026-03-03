# README — Evidencia BI vs SQL/CSV  

## Dashboard: LIC (Licitaciones)

---

## Propósito

Este directorio contiene la evidencia generada para el dashboard **LIC**, incluyendo:

- extracción de KPIs desde SQL (DW_SEM),
- registro de KPIs capturados desde Power BI,
- comparación numérica BI vs SQL,
- outputs CSV y logs asociados.

---

## 1) Ubicación del módulo

Ruta relativa del módulo:

```text
./Evidencia_BI_vs_SQL/LIC/
```

---

## 2) Notebook principal

Notebook responsable de generar los outputs de auditoría:

```text
LIC_Evidencia_BI_vs_SQL_v9.ipynb
```

Ubicación esperada:

```text
./Evidencia_BI_vs_SQL/LIC/LIC_Evidencia_BI_vs_SQL_v9.ipynb
```

---

## 3) Outputs oficiales

Los outputs generados por el notebook se almacenan en:

```text
./Evidencia_BI_vs_SQL/LIC/outputs/
```

---

## 4) Archivos generados (outputs)

Archivos principales:

- `lic_kpis_sql.csv`  
  KPIs calculados desde SQL (fuente DW_SEM).

- `lic_kpis_sql.log`  
  Log de ejecución SQL asociado a la extracción de KPIs.

- `lic_kpis_bi.csv`  
  KPIs registrados desde Power BI para el dashboard LIC (segmentados por moneda).

- `lic_kpis_bi_vs_sql.csv`  
  Archivo comparativo final BI vs SQL. Incluye diferencias absolutas y porcentuales, además de estado de consistencia.

---

## 5) Criterio de validación aplicado

El dashboard LIC opera con segmentación explícita por **Moneda**.

Por lo tanto:

- Los KPIs se validan por moneda (CLP, USD, CLF, EUR y categoría especial MONEDA REVISAR).
- Los KPIs sin moneda (`NONE`, `_Global`) no forman parte del comportamiento del dashboard y se marcan como `NO_APLICA` en el archivo comparativo.

---

## 6) Regla operativa: multimoneda

Los montos se interpretan exclusivamente dentro de la moneda seleccionada.

- No se realizan conversiones.
- No se suman montos entre monedas distintas.
- Los resultados dependen del filtro activo de moneda.

---

## 7) Estructura esperada del directorio

```text
./Evidencia_BI_vs_SQL/LIC/
│
├── LIC_Evidencia_BI_vs_SQL_v9.ipynb
├── README_LIC.md
│
└── outputs/
    ├── lic_kpis_bi.csv
    ├── lic_kpis_sql.csv
    ├── lic_kpis_bi_vs_sql.csv
    └── lic_kpis_sql.log
```

---

## 8) Resultado esperado del proceso

El archivo `lic_kpis_bi_vs_sql.csv` debe contener:

- valores SQL y BI por KPI y moneda,
- diferencias calculadas (`diff_abs`, `diff_pct`),
- estado final (`OK`, `NO_OK_SQL0`, `FALTA_SQL`, `FALTA_PBI`, `NO_APLICA`).

---

## 9) Historial de versiones

- Notebook actual: `LIC_Evidencia_BI_vs_SQL_v9.ipynb`

---

Fin del documento.
