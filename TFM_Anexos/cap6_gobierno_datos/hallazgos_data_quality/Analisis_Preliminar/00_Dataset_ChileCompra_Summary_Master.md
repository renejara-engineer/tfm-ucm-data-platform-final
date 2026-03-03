# Dataset ChileCompra – Summary Master (facts-first)

> Generado por `build_hallazgos.py`. Este README es un placeholder técnico.
> La redacción final TFM debe construirse a partir de `04_Hallazgos/`.

## Evidencias principales

- `04_Hallazgos/findings.json`
- `04_Hallazgos/*_file_summary.csv`
- `04_Hallazgos/*_dict.md`
- `04_Hallazgos/relationships_metrics.json` + `relationships_examples.csv`
- `04_Hallazgos/quality_gates_summary.csv` + `incidents.jsonl`
- `04_Hallazgos/postgres_design_notes.md` + `postgres_recommendations.sql`

## Reproducibilidad

```bash
python build_hallazgos.py --mode full --base-dir <SOURCE_DATA_REPO_OR_PATH>
```
