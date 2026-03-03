# Evidencia técnica — Extracción y Normalización

Este documento complementa el Capítulo 4 del informe,
aportando evidencia concreta del proceso de extracción
y normalización implementado en la ChileCompra Data Platform.

---

## 1. Flujo general de transformación

El proceso ETL sigue la siguiente secuencia:

INBOX (archivos CSV mensuales)
→ STG (carga estructural en PostgreSQL)
→ Validaciones estructurales
→ Transformación a modelo dimensional (DW)

Cada período mensual se procesa bajo reglas uniformes,
evitando cargas parciales o inconsistentes.

---

## 2. Estructura de archivo fuente (ejemplo)

Archivo original descargado desde portal de datos abiertos:

- Licitaciones_2024_10.csv

Columnas originales (extracto):

- CodigoLicitacion
- NombreOrganismo
- FechaPublicacion
- Estado
- MontoEstimado
- Moneda
- ProveedorAdjudicado

Estos archivos se almacenan en:

data/ChileCompraDL/00_INBOX/{periodo}/

---

## 3. Normalización aplicada

Durante la fase STG se aplican las siguientes transformaciones:

- Conversión de tipos de datos (fecha, numérico, texto).
- Estandarización de nombres de columnas.
- Eliminación de duplicados intra-período.
- Validación de claves primarias naturales.
- Registro de decisiones de carga por período.

Ejemplo conceptual:

Antes (CSV):
FechaPublicacion = "15/10/2024"

Después (STG):
fecha_publicacion = DATE '2024-10-15'

Antes:
Moneda = "CLP"

Después:
moneda_codigo = 'CLP' (validado contra catálogo)

---

## 4. Control de consistencia

Para cada período procesado se registran:

- Volumen de registros cargados.
- Registros descartados.
- Validación de integridad referencial.
- Estado final del proceso.

Estas decisiones se almacenan en la tabla:

dw.etl_decisiones_periodo

---

## 5. Relación con capítulos posteriores

El resultado de esta fase alimenta directamente:

- Capítulo 5 — Modelo dimensional.
- Capítulo 6 — Gobierno de datos.
- Capítulo 7 — Operación reproducible.

La consistencia estructural del DW depende
directamente de la calidad del proceso descrito aquí.