# Diccionario de Datos – Data Warehouse (DW v1)

_TFM – ChileCompra Data Platform (UCM)_  
_Este documento describe el diccionario de datos del Data Warehouse (DW) implementado en PostgreSQL, versión v1._

---

## 1. Convenciones generales

- Esquema PostgreSQL: `dw`
- Claves primarias técnicas: `*_sk` (surrogate keys, `BIGINT / INTEGER`)
- Claves naturales: `*_bk`
- El campo `periodo` representa el mes de extracción (`YYYY-MM`)
- Las columnas `*_sk` pueden ser `NULL` cuando el dato no está disponible en origen
- Timestamps del sistema: `ingested_at`

---

## 2. Dimensiones

### 2.1 `dw.dim_fecha`

| Columna           | Tipo      | Descripción                   |
|-------------------|-----------|-------------------------------|
| fecha_sk          | INTEGER   | Clave surrogate de la fecha   |
| fecha             | DATE      | Fecha calendario              |
| anio              | INTEGER   | Año                           |
| mes               | INTEGER   | Mes (1–12)                    |
| dia               | INTEGER   | Día del mes                   |
| trimestre         | INTEGER   | Trimestre (1–4)               |
| nombre_mes        | TEXT      | Nombre del mes                |
| es_fin_de_semana  | BOOLEAN   | Indicador fin de semana       |

---

### 2.2 `dw.dim_organismo`

| Columna           | Tipo    | Descripción                             |
|-------------------|---------|-----------------------------------------|
| organismo_sk      | INTEGER | Clave surrogate del organismo           |
| codigo_organismo  | TEXT    | Código oficial del organismo comprador  |
| nombre_organismo  | TEXT    | Nombre del organismo                    |
| nivel             | TEXT    | Nivel administrativo                    |
| region            | TEXT    | Región                                  |
| comuna            | TEXT    | Comuna                                  |

---

### 2.3 `dw.dim_proveedor`

| Columna           | Tipo    | Descripción                   |
|-------------------|---------|-------------------------------|
| proveedor_sk      | INTEGER | Clave surrogate del proveedor |
| codigo_proveedor  | TEXT    | Identificador del proveedor   |
| nombre_proveedor  | TEXT    | Nombre del proveedor          |
| pais              | TEXT    | País del proveedor            |

---

### 2.4 `dw.dim_producto_onu`

| Columna               | Tipo      | Descripción                  |
|-----------------------|-----------|------------------------------|
| producto_onu_sk       | INTEGER   | Clave surrogate del producto |
| codigo_producto_onu   | TEXT      | Código ONU                   |
| descripcion_producto  | TEXT      | Descripción del producto     |
| nivel_1               | TEXT      | Categoría ONU nivel 1        |
| nivel_2               | TEXT      | Categoría ONU nivel 2        |
| nivel_3               | TEXT      | Categoría ONU nivel 3        |

---

## 3. Tablas de Hechos

### 3.1 `dw.fact_licitaciones`

| Columna               | Tipo          | Descripción                               |
|-----------------------|---------------|-------------------------------------------|
| licitacion_sk         | BIGINT        | Clave surrogate                           |
| licitacion_bk         | TEXT          | Identificador natural de la licitación    |
| fecha_publicacion_sk  | INTEGER       | FK a `dim_fecha`                          |
| fecha_cierre_sk       | INTEGER       | FK a `dim_fecha`                          |
| organismo_sk          | INTEGER       | FK a `dim_organismo`                      |
| proveedor_sk          | INTEGER       | FK a `dim_proveedor`                      |
| producto_onu_sk       | INTEGER       | FK a `dim_producto_onu`                   |
| monto_estimado        | NUMERIC(18,2) | Monto estimado                            |
| monto_adjudicado      | NUMERIC(18,2) | Monto adjudicado                          |
| cantidad_items        | INTEGER       | Cantidad de ítems                         |
| estado_licitacion     | TEXT          | Estado de la licitación                   |
| tipo_licitacion       | TEXT          | Tipo de procedimiento                     |
| moneda                | TEXT          | Moneda                                    |
| periodo               | TEXT          | Periodo de carga (`YYYY-MM`)              |
| source_file           | TEXT          | Archivo de origen                         |
| ingested_at           | TIMESTAMP     | Timestamp de carga                        |

---

### 3.2 `dw.fact_ordenes_compra`

| Columna               | Tipo          | Descripción                       |
|-----------------------|---------------|-----------------------------------|
| orden_compra_sk       | BIGINT        | Clave surrogate                   |
| orden_compra_bk       | TEXT          | Identificador natural de la orden |
| fecha_creacion_sk     | INTEGER       | FK a `dim_fecha`                  |
| fecha_aceptacion_sk   | INTEGER       | FK a `dim_fecha`                  |
| organismo_sk          | INTEGER       | FK a `dim_organismo`              |
| proveedor_sk          | INTEGER       | FK a `dim_proveedor`              |
| producto_onu_sk       | INTEGER       | FK a `dim_producto_onu`           |
| monto_total           | NUMERIC(18,2) | Monto total                       |
| cantidad_total        | NUMERIC(18,2) | Cantidad total                    |
| cantidad_items        | INTEGER       | Número de ítems                   |
| estado_oc             | TEXT          | Estado de la orden                |
| tipo_oc               | TEXT          | Tipo de orden                     |
| moneda                | TEXT          | Moneda                            |
| periodo               | TEXT          | Periodo de carga (`YYYY-MM`)      |
| source_file           | TEXT          | Archivo de origen                 |
| ingested_at           | TIMESTAMP     | Timestamp de carga                |

---

## 4. Notas de modelado

- El DW v1 implementa un **modelo estrella** con dos tablas de hechos.
- El diseño prioriza **análisis agregados**, no réplica operacional.
- Columnas CLEAN no utilizadas se documentan en `summary_master_v2.md`.
- El DW está preparado para cargas incrementales mensuales (idempotencia por BK + periodo).

---
