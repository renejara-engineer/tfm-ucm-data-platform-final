# ANEXOS_MODELO_PBI (Evidencia Modelo Semántico)

Fuente: `TFM_BI_ChileCompra_Report+Model.zip`

Este directorio contiene artefactos extraídos automáticamente desde el modelo semántico Power BI (`model.bim`)
y el reporte (`report.json`) para respaldar auditoría de trazabilidad DW→DAX→KPI.

## Resumen objetivo del modelo (extraído desde model.bim)

- Tablas totales: 32
- Relaciones totales: 18
- Medidas DAX totales: 64
- Particiones totales: 32

### Clasificación de fuentes detectadas en particiones (Power Query M)

- CSV: 14
- PostgreSQL (DW): 9

> Nota: La clasificación se realiza detectando patrones en expresiones M (`File.Contents`, `.csv`, `PostgreSQL.Database`, `dw_sem`).

## Archivos generados

- `PBI_model_summary.json`  
  Resumen del modelo.

- `PBI_model_tables_inventory.csv`  
  Inventario de tablas del modelo: nombre, oculto, nº columnas, nº medidas, nº particiones.

- `PBI_model_partitions_sources.csv`  
  Evidencia de fuentes por tabla/partición. Incluye expresión M completa y clasificación CSV vs PostgreSQL.

- `PBI_model_relationships.csv`  
  Relaciones entre tablas del modelo (fromTable/fromColumn → toTable/toColumn).

- `PBI_model_measures.csv`  
  Medidas DAX extraídas directamente desde el modelo (nombre, expresión, formato).

## Uso en auditoría Fase 7

Este inventario permite demostrar ante tribunal:

1) Que el modelo Power BI contiene medidas DAX explícitas (sin lógica oculta).
2) Que existen tablas cargadas desde PostgreSQL (DW) y desde CSV (outputs notebook).
3) Que DT_TEND/DT_SECT están basados en CSV (evidencia por particiones M).
4) Que LIC/OC/RECON se conectan a vistas DW (`dw_sem.*`) (evidencia por particiones M).
