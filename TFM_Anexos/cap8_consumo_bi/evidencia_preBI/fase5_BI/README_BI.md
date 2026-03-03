# TFM — Fase 5 BI (Evidence Kit)

Este directorio contiene el **kit reproducible y operativo** para ejecutar notebooks BI en **VS Code**
usando el entorno **tfm (Conda)** y conectándose al **Data Warehouse PostgreSQL** del TFM.

El objetivo es eliminar ambigüedades y permitir trabajar BI de forma **ordenada, trazable y defendible**.

---

## 🎯 Objetivo

- Reconstruir el entorno **desde cero** con **Python 3.10.19** y librerías fijadas.
- Ejecutar notebooks de evidencia y BI (BI-0) en VS Code **sin dependencias ocultas**.
- Validar conectividad real al DW PostgreSQL (Docker).
- Dejar evidencia reproducible para memoria y defensa del TFM.

---

## 📌 Fuente única del entorno

- `environment.yml` es la **FUENTE ÚNICA** del entorno Python.
- No se mantiene `librerias.txt` como fuente paralela (evitar drift).
- Cualquier cambio de librerías debe reflejarse **solo** en `environment.yml`.

---

## 🧭 SECUENCIA OPERATIVA RECOMENDADA (ORDEN OBLIGATORIO)

### PASO 0 — Posicionamiento correcto

```bash
cd ~/Documents/Proyectos/TFM/docs/evidence/fase5_BI
```

---

### PASO 1 — Crear entorno Python BI (desde cero)

```bash
conda deactivate
conda env remove -n tfm -y
conda env create -f environment.yml
conda activate tfm
python --version
```

Resultado esperado:

```bash
Python 3.10.19
```

Registrar kernel:

```bash
python -m ipykernel install --user --name tfm --display-name "Python (TFM)"
```

Abrir VS Code:

```bash
code .
```

---

### PASO 2 — Levantar servicios Docker (DW)

```bash
cd ~/Documents/Proyectos/TFM
./02-tfm.sh up
./03-status.sh
```

---

### PASO 3 — Variables de conexión PostgreSQL

```bash
export PG_HOST=localhost
export PG_PORT=5433
export PG_DB=chilecompra
export PG_USER=chile_user
export PG_PASS='CHANGE_ME'
```

---

### PASO 4 — Ejecución de notebooks BI

Orden obligatorio:

1. `TFM_Fase5_BI_00_Check_Entorno.ipynb`
2. `TFM_Fase5_BI_01_Contrato_KPIs_SQL.ipynb`

---

## 🎓 Criterio académico

- SQL es la fuente de verdad.
- Todo KPI debe validarse en SQL antes de Power BI.
- NO-OP y EXCEPCIÓN son decisiones válidas y trazables.

**Fase BI lista para ejecución defendible en tribunal.**

---

## ✅ Estado de la fase

BI-0 (Contrato de KPIs): CERRADA

Este directorio queda congelado como evidencia técnica reproducible.
Los outputs CSV representan el contrato analítico oficial utilizado para
el diseño de dashboards BI posteriores.

Cualquier modificación implica abrir una nueva fase (BI-1).

---

## Nota operativa sobre el entorno

El entorno BI se apoya en un Data Warehouse validado y estable.
La operación del stack Docker se realiza mediante los scripts:

- `02-tfm.sh` (arranque/parada controlada)
- `03-status.sh` (auditoría de estado)

Los mensajes históricos de arranque observables en logs de PostgreSQL
no representan fallos activos ni afectan la capa BI.

---

## 2026-01-24 — BI · HITO BI-1 · Reconciliación DW vs Power BI (Periodo 2024-09)

Se completa y valida la reconciliación entre métricas del Data Warehouse
(PostgreSQL) y Power BI para el período 2024-09.

### Evidencias técnicas

- SQL de reconciliación:
  - docs/evidence/fase5_BI/powerbi/sql/recon_2024_09.sql
- Log de ejecución (Docker + psql):
  - docs/evidence/fase5_BI/powerbi/sql/recon_2024_09.log
- Modelo Power BI:
  - Hoja: RECON_2024_09
  - Medidas DAX: LIC Count, OC Count, LIC Monto Total, OC Monto Total
- Captura modelo estrella:
  - docs/evidence/fase5_BI/powerbi/capturas/01_modelo_relaciones.png

### Resultado

Los valores obtenidos en Power BI coinciden con los resultados del DW
para conteos y montos (LIC y OC), considerando redondeos propios del visual.

HITO BI-1 cerrado y aceptado.

---
