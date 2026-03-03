# README — Automatización del pipeline: importación del workflow (n8n)

Este repositorio corresponde al TFM **“ChileCompra Data Platform” (UCM)**.

⚠️ **Los datos masivos oficiales (CSV mensuales ChileCompra) NO están incluidos en GitHub** por tamaño y buenas prácticas de publicación.

Este documento explica cómo descargar y ubicar los archivos para ejecutar el pipeline localmente.

---

## 1. Ruta esperada del Data Lake

El proyecto utiliza un Data Lake con estructura por zonas:

```text
TFM_UCM/data/ChileCompraDL/
├── 01_RAW/
├── 02_INBOX/
├── 02_CLEAN/
├── 03_MART/
└── 04_Metadata/
```

La ruta del Data Lake se define en `.env.local` mediante:

```bash
DATA_LAKE_ROOT=./data/ChileCompraDL
```

En ejecución dockerizada, esta ruta se monta dentro del contenedor como:

- `/data_lake`

---

## 2. Datos requeridos (mínimo para DEMO)

Para ejecutar la DEMO del pipeline se requiere al menos **1 período mensual** con:

- LIC (Licitaciones)
- OC (Órdenes de Compra)

Ejemplo recomendado:

- `2024-09`

---

## 3. Convención de nombres y períodos

Formato obligatorio del período:

- `YYYY-MM`

Ejemplos válidos:

- `2024-09`
- `2024-10`
- `2025-01`

Formato esperado de archivos:

- `LIC_YYYY-MM.csv`
- `OC_YYYY-MM.csv`

Ejemplo:

- `LIC_2024-09.csv`
- `OC_2024-09.csv`

---

## 4. Ubicación de descarga (RAW)

Los archivos descargados deben ubicarse inicialmente en:

### 4.1 Licitaciones (LIC)

data/ChileCompraDL/01_RAW/LIC/

### 4.2 Órdenes de Compra (OC)

data/ChileCompraDL/01_RAW/OC/

Ejemplo final:

```txt
data/ChileCompraDL/01_RAW/LIC/LIC_2024-09.csv
data/ChileCompraDL/01_RAW/OC/OC_2024-09.csv
```

---

## 5. Preparación de ejecución DEMO (INBOX)

El pipeline DEMO no procesa toda la historia RAW.
En su lugar, utiliza la carpeta `02_INBOX` como entrada controlada.

Para preparar el período `2024-09`, los archivos deben estar en:

```text
data/ChileCompraDL/02_INBOX/LIC/2024-09/LIC_2024-09.csv
data/ChileCompraDL/02_INBOX/OC/2024-09/OC_2024-09.csv
```

---

## 6. Comandos para copiar un período desde RAW a INBOX

Ejemplo para preparar el período `2024-09`:

```bash
mkdir -p data/ChileCompraDL/02_INBOX/LIC/2024-09
mkdir -p data/ChileCompraDL/02_INBOX/OC/2024-09

cp data/ChileCompraDL/01_RAW/LIC/LIC_2024-09.csv data/ChileCompraDL/02_INBOX/LIC/2024-09/
cp data/ChileCompraDL/01_RAW/OC/OC_2024-09.csv data/ChileCompraDL/02_INBOX/OC/2024-09/
```

---

## 7. Ejecución del pipeline (DEMO)

Una vez los datos están en `02_INBOX`, se puede ejecutar la carga del período mediante:

- Workflow n8n `TFM_ver6.0`
- o ejecución manual ETL (Python dentro del contenedor)

Luego se valida la carga en el Data Warehouse mediante:

- `dw.etl_control_cargas`
- vistas semánticas `dw_sem`

---

## 8. Política GitHub (importante)

Este repositorio **NO debe contener datos masivos**, especialmente:

- archivos `.csv`
- archivos `.zip` de datos oficiales
- dumps grandes

La estructura del Data Lake se publica únicamente como referencia reproducible.

---

## 9. Nota académica (UCM)

El objetivo es demostrar reproducibilidad técnica del pipeline:

RAW → CLEAN → MART → DW → SEM → BI**

Los datos oficiales son externos y deben descargarse manualmente por el usuario.

---
