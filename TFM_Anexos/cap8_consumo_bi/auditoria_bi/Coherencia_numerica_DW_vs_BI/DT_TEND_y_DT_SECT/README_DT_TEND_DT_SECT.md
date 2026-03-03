# README — Evidencia BI vs SQL/CSV  

## Dashboards: DT_TEND y DT_SECT (Cruce LIC–OC)

---

## 0) Propósito

Este directorio contiene la evidencia generada para los dashboards **DT_TEND** y **DT_SECT**, los cuales forman parte del módulo de análisis agregado del cruce **LIC–OC**.

Los archivos aquí almacenados permiten:

- reproducir la generación de datasets agregados,
- mantener trazabilidad entre notebook → output → consumo en Power BI,
- conservar outputs CSV utilizados directamente por los dashboards.

---

## 1) Ubicación del módulo

Ruta relativa del módulo:

```text
./Evidencia_BI_vs_SQL/DT_TEND_y_DT_SECT/
```

---

## 2) Notebook principal

El notebook responsable de generar los outputs utilizados por estos dashboards es:

```text
Evidencia_DT_TEND_DT_SECT_v4.ipynb
```

Ubicación esperada:

```text
./Evidencia_BI_vs_SQL/DT_TEND_y_DT_SECT/Evidencia_DT_TEND_DT_SECT_v4.ipynb
```

---

## 3) Outputs oficiales (CSV)

Los outputs generados por el notebook se almacenan en:

```text
./Evidencia_BI_vs_SQL/DT_TEND_y_DT_SECT/outputs/02_Cruce/
```

Estos archivos CSV son consumidos en Power BI para construir KPIs, tablas y gráficos en los dashboards DT_TEND y DT_SECT.

---

## 4) Archivos de salida incluidos

Archivos principales utilizados por los dashboards:

- `D6_trend_por_mes.csv`  
  Dataset de tendencia temporal del cruce LIC–OC por período.

- `D6_oc_con_sin_lic_por_mes.csv`  
  Dataset mensual de OC con/sin LIC asociada.

- `D6_kpi_resumen.csv`  
  Resumen agregado de KPIs globales del módulo cruce.

- `D6_cruces_sector_moneda.csv`  
  Dataset agregado por sector del Estado y moneda.

- `D6_dist_oc_por_lic.csv`  
  Distribución agregada de OC por LIC.

- `D6_dist_lic_por_oc.csv`  
  Distribución agregada de LIC por OC.

Archivos auxiliares de control:

- `D6_alerta_moneda_oferta.csv`  
  Dataset de alerta/control asociado a multimoneda.

- `D6_moneda_mapeo_std.csv`  
  Mapeo estándar de moneda.

- `D6_control_meses_lic.csv`  
  Control de meses disponibles para LIC.

- `D6_control_meses_oc.csv`  
  Control de meses disponibles para OC.

---

## 5) Archivo de trazabilidad (mapa notebook → output → dashboard)

El archivo:

```text
trace_csv_notebook_map.xlsx
```

contiene un registro explícito de trazabilidad con:

- notebook de origen,
- ruta relativa del output dentro del repositorio,
- ruta física donde el archivo se ubica para consumo en Power BI (Windows),
- dashboard donde se utiliza.

Ubicación esperada:

```text
./Evidencia_BI_vs_SQL/DT_TEND_y_DT_SECT/trace_csv_notebook_map.xlsx
```

---

## 6) Consumo en Power BI (Windows)

Power BI consume estos outputs desde un directorio de trabajo en Windows.

Ejemplo típico:

```text
<POWERBI_WORKDIR>\02_Cruce\
```

Los archivos CSV generados en el repositorio deben copiarse hacia dicho directorio para ser cargados por Power BI.

---

## 7) Estructura esperada del directorio

```text
./Evidencia_BI_vs_SQL/DT_TEND_y_DT_SECT/
│
├── Evidencia_DT_TEND_DT_SECT_v4.ipynb
├── README_DT_TEND_DT_SECT.md
├── trace_csv_notebook_map.xlsx
│
└── outputs/
    └── 02_Cruce/
        ├── D6_trend_por_mes.csv
        ├── D6_oc_con_sin_lic_por_mes.csv
        ├── D6_kpi_resumen.csv
        ├── D6_cruces_sector_moneda.csv
        ├── D6_dist_oc_por_lic.csv
        ├── D6_dist_lic_por_oc.csv
        ├── D6_alerta_moneda_oferta.csv
        ├── D6_moneda_mapeo_std.csv
        ├── D6_control_meses_lic.csv
        └── D6_control_meses_oc.csv
```

---

## 8) Notas operativas

- Los outputs están organizados por módulo (`02_Cruce`) para mantener consistencia con la estructura histórica del proyecto.
- Este módulo corresponde a evidencia agregada del cruce LIC–OC, no a datos transaccionales directos.
- La ejecución del notebook debe generar outputs consistentes con los archivos listados en este README.

---

## 9) Historial de versiones

- Notebook actual: `Evidencia_DT_TEND_DT_SECT_v4.ipynb`

---

Fin del documento.
