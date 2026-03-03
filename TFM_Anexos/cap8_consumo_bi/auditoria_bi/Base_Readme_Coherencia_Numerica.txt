Elaboracion Readme Maestro para Auditoria "Coherencia numérica DW vs CSV"

Archivos utilizados:
- v5_medidas_dax_ver5.0.tsv
- v5_TFM_ReneJara_ChileCompra_FaseBI_PowerBI_2024-09_2025-10_v5.pdf
- v5_Report+SemanticModel.zip

Listado de Dashboard:
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

Dashboards auditados
- LIC
- DT_TEND y DT_SECT
- OC
- RECON

Chat HTML que permitieron el desarrollo de esta auditoria:
- TFM_Fase7_Auditoria_01-03-1.html
- TFM_Fase7_Auditoria_01-03-2.html
- TFM_Fase7_Auditoria_01-03-3.html
- TFM_Fase7_Auditoria_01-03-4.html
- TFM_Fase7_Auditoria_01-03-5.html
- TFM_Fase7_Auditoria_01-03-6.html

Estos chat se desarrollan para cumplir el chat maestro en lo que respecta a "CHAT 3 — Coherencia numérica DW vs CSV"


Dashboards no auditados individualmente (fuera de alcance por no materialidad / redundancia):

- LIC_EST: no se audita de forma independiente por tratarse de una vista derivada del dashboard LIC, reutilizando la misma capa semántica y medidas base. 
  Su consistencia queda cubierta por la auditoría madre LIC y la auditoría transversal de filtros.

- CRUCE_COD: no se audita con comparación numérica completa por corresponder a un dashboard auxiliar exploratorio de cruce, no considerado evidencia principal del modelo BI. 
  Su coherencia estructural queda cubierta por auditorías de dashboards derivados (DT_TEND / DT_SECT) y por validaciones transversales del modelo.
  
  NO_CRUCE — Estado auditoría: no se audita dado que este dashboard/página cumple una función de control metodológico, orientada a declarar explícitamente restricciones del 
  modelo (p. ej., limitaciones de cruce o comparabilidad). No contiene KPIs cuantitativos ni medidas numéricas sujetas a verificación BI↔SQL. 
  Por lo tanto, la auditoría KPI↔SQL no es aplicable.
  La validación pertinente se limita a confirmar existencia, visibilidad y coherencia del mensaje metodológico y su correcta integración en la navegación del reporte, 
  sin exigir contraste numérico con consultas SQL.
  
Dashboards que no aplica auditoria
- MENU
- INFO
- HALLAZGOS


directorio Actual

├── Coherencia_numerica_DW_vs_BI
│   ├── DT_TEND_y_DT_SECT
│   │   ├── Evidencia_DT_TEND_DT_SECT_v4.ipynb
│   │   ├── README_DT_TEND_DT_SECT.md
│   │   ├── outputs
│   │   │   └── 02_Cruce
│   │   │       ├── D6_alerta_moneda_oferta.csv
│   │   │       ├── D6_control_meses_lic.csv
│   │   │       ├── D6_control_meses_oc.csv
│   │   │       ├── D6_cruces_sector_moneda.csv
│   │   │       ├── D6_dist_lic_por_oc.csv
│   │   │       ├── D6_dist_oc_por_lic.csv
│   │   │       ├── D6_kpi_resumen.csv
│   │   │       ├── D6_moneda_mapeo_std.csv
│   │   │       ├── D6_oc_con_sin_lic_por_mes.csv
│   │   │       └── D6_trend_por_mes.csv
│   │   └── trace_csv_notebook_map.xlsx
│   ├── LIC
│   │   ├── LIC_Evidencia_BI_vs_SQL_v9.ipynb
│   │   ├── README_LIC.md
│   │   └── outputs
│   │       ├── lic_kpis_bi.csv
│   │       ├── lic_kpis_bi_vs_sql.csv
│   │       ├── lic_kpis_sql.csv
│   │       └── lic_kpis_sql.log
│   ├── OC
│   │   ├── OC_Evidencia_BI_vs_SQL_v4.ipynb
│   │   ├── README_OC.md
│   │   └── outputs
│   │       ├── oc_kpis_bi.csv
│   │       ├── oc_kpis_bi_vs_sql.csv
│   │       ├── oc_kpis_sql.csv
│   │       └── oc_kpis_sql.log
│   └── RECON
│       ├── README_RECON.md
│       ├── RECON_Evidencia_BI_vs_SQL_v6.ipynb
│       └── outputs
│           ├── recon_bi_vs_sql_csv.xlsx
│           ├── recon_kpis_bi_template.csv
│           ├── recon_kpis_bi_vs_sql.csv
│           ├── recon_kpis_sql.csv
│           └── recon_kpis_sql.log
└── arbol.sh

11 directories, 33 files











📊 2️⃣ v5_medidas_dax_ver5.0.tsv
🎯 Rol: Fuente de auditoría lógica (capa de cálculo)

Se utiliza para:

Analizar la totalidad de medidas DAX.

Identificar:

Dependencias circulares.

Uso excesivo de CALCULATE.

Filtros mal definidos.

Uso incorrecto de ALL / REMOVEFILTERS.

Evaluar:

Estandarización de nombres.

Complejidad innecesaria.

Medidas duplicadas.

👉 Es la base para auditar la calidad técnica de la lógica analítica.

🧱 3️⃣ v5_Report+SemanticModel.zip
🎯 Rol: Auditoría estructural del modelo tabular

Permite validar:

Esquema estrella real vs declarado.

Cardinalidades correctas (1:*).

Direccionalidad de filtros.

Relaciones activas/inactivas.

Uso correcto de tablas puente.

Normalización dimensional.

👉 Es el insumo para auditar arquitectura y diseño del modelo BI.

📘 4️⃣ v5_TFM_ReneJara_ChileCompra_FaseBI_PowerBI_2024-09_2025-10_v5.pdf
🎯 Rol: Validación de coherencia académica y metodológica

Sirve para:

Contrastar lo implementado vs lo declarado.

Verificar cumplimiento de objetivos.

Revisar consistencia metodológica.

Confirmar alineación con marco conceptual.

👉 Es la referencia de validación conceptual y académica.

🧩 Cómo se integran en la Auditoría 01–03

En esta versión la auditoría se estructura en tres bloques principales:

Bloque	Capa auditada	Archivo clave
01	Arquitectura del modelo	SemanticModel.zip
02	Lógica de negocio (DAX)	TSV medidas
03	Coherencia metodológica	PDF TFM












