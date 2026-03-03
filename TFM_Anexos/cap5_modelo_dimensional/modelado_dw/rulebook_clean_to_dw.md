# Rulebook de Transformación CLEAN → DW (v1)

_TFM – ChileCompra Data Platform (UCM)_  
_Este rulebook define las reglas formales para transformar los datasets de la capa 02_CLEAN del Data Lake en el modelo dimensional DW en PostgreSQL._

## 1. Alcance y contexto

### 1.1 Origen de datos y rutas físicas

El Data Lake reside en el disco externo:

- Root: `${DATA_LAKE_ROOT}`

Capas oficiales:

- `01_RAW/` – datos fuente sin transformar.
- `02_CLEAN/` – datos normalizados y validados a nivel fila/columna.
- `03_MART/` – capas analíticas / outputs agregados (pendiente de poblar).
- `04_Metadata/` – esquemas y metadata técnica.

Para el DW v1 se utilizan como **fuentes de verdad**:

- Licitaciones (LIC) – capa CLEAN:

  - Ruta: `${DATA_LAKE_ROOT}/02_CLEAN/LIC/manual_csv/`
  - Patrón de archivo: `lic_YYYY-MM.parquet`

- Órdenes de Compra (OC) – capa CLEAN:

  - Ruta: `${DATA_LAKE_ROOT}/02_CLEAN/OC/manual_csv/`
  - Patrón de archivo: `oc_YYYY-MM.parquet`

- Organismos compradores (maestro):

  - Ruta RAW: `${DATA_LAKE_ROOT}/01_RAW/OrganismosCompradores/2025-10-17_Listado_organismos_compradores.csv`
  - En Fase 3 se carga y normaliza en una tabla de staging específica antes de poblar la dimensión `dim_organismo`.

### 1.2 Fuentes explícitamente fuera de alcance para DW v1

Aunque el Data Lake contiene datos OCDS y páginas crudas:

- `${DATA_LAKE_ROOT}/01_RAW/OCDS/combined/...`
- `${DATA_LAKE_ROOT}/01_RAW/OCDS/raw_pages/...`

estos ficheros **NO se utilizan en DW v1**.  
Se documentan como fuentes complementarias para análisis futuros, pero el DW inicial se basa exclusivamente en:

- descargas masivas LIC / OC (CLEAN parquet), y  
- maestro de organismos compradores.

### 1.3 Esquemas de referencia (metadata CLEAN)

Los esquemas técnicos de LIC y OC en la capa CLEAN se documentan en:

- `${DATA_LAKE_ROOT}/04_Metadata/schemas/schema_lic_clean_any.csv`
- `${DATA_LAKE_ROOT}/04_Metadata/schemas/schema_oc_clean_any.csv`

Adicionalmente, el documento:

- `docs/metada/summary_master_v2.md`

recoge el **profiling global** de todas las columnas (tipos, nulos, cardinalidades, anomalías) y actúa como **fuente de verdad de metadata observacional** para este rulebook.

---

## 2. Convenciones generales para el DW

### 2.1 Esquema lógico y físico

- Esquema lógico: modelo dimensional estrella doble con dos tablas de hechos:
  - `Fact_Licitaciones`
  - `Fact_OrdenesCompra`
- Esquema físico en PostgreSQL:
  - Nombre del esquema: `dw`
  - Tablas físicas:
    - `dw.dim_organismo`
    - `dw.dim_proveedor`
    - `dw.dim_producto_onu`
    - `dw.dim_fecha`
    - `dw.fact_licitaciones`
    - `dw.fact_ordenes_compra`

### 2.2 Claves técnicas y naturales

- Cada tabla de dimensión y de hechos tendrá una **clave primaria técnica** entera (`*_sk`), implementada como:

  ```sql
  GENERATED ALWAYS AS IDENTITY

## 3. Hallazgos empíricos que impactan el diseño del DW

Las decisiones de diseño del modelo dimensional y del modelo físico del Data Warehouse no se basan en supuestos teóricos, sino en un análisis empírico de los datasets reales de ChileCompra.

Este análisis se materializa en el paquete de hallazgos ubicado en:

- `docs/hallazgos/2025-12-15_build_hallazgos/`

El contenido de este directorio (profiling, métricas de relaciones, quality gates y recomendaciones técnicas) constituye **evidencia técnica formal** para las decisiones documentadas en este rulebook.

---

### 3.1 Organismos compradores: ausencia de correspondencia con maestro oficial

#### 3.1.1 Hallazgo

El análisis de intersección entre los códigos de organismo presentes en LIC y OC y el maestro oficial de organismos compradores muestra **ausencia de correspondencia 1:1 por código**.

Este resultado se documenta en:

- `relationships_metrics.json`
- `relationships_examples.csv`

#### 3.1.2 Impacto en el diseño

- La dimensión `dim_organismo` se construye **principalmente a partir de los códigos observados en LIC y OC**.
- El maestro de organismos se utiliza únicamente como **fuente de enriquecimiento opcional**, sin imponer claves foráneas estrictas.
- Se evita el diseño de una clave foránea artificial que no puede garantizar integridad referencial real.

---

### 3.2 Proveedores: definición de clave natural

#### 3.2.1 Hallazgo

El análisis de relaciones muestra que:

- Los nombres de proveedor presentan variabilidad y baja confiabilidad como identificador.
- Los códigos de proveedor presentan mayor estabilidad relativa entre LIC y OC.

#### 3.2.2 Impacto en el diseño

- La dimensión `dim_proveedor` adopta `codigo_proveedor` como **clave natural**.
- El nombre del proveedor se modela como atributo descriptivo, sujeto a normalización y cambios.
- Esta decisión reduce duplicidad artificial de proveedores en el DW.

---

### 3.3 Duplicados y repetición intermensual

#### 3.3.1 Hallazgo

El análisis de calidad detecta:

- Duplicados significativos en ciertos meses de LIC.
- Repetición de hashes intermensuales en LIC y OC (`inter_month_repeated_hashes_*.csv`).

#### 3.3.2 Impacto en el diseño

- Se define una política explícita de **deduplicación en la capa CLEAN y/o staging** antes de poblar el DW.
- El DW asume que las tablas de hechos reciben datos ya deduplicados según las reglas definidas en este rulebook.
- Los duplicados detectados alimentan las validaciones definidas en `sql/quality_checks.sql`.

---

### 3.4 Meses anómalos y archivos incompletos

#### 3.4.1 Hallazgo

Se identifican meses con volúmenes anómalos (archivos con muy pocas filas), documentados en:

- `raw_inventory_lic.csv`
- `raw_inventory_oc.csv`
- `quality_gates_summary.csv`

#### 3.4.2 Impacto en el diseño

- Se definen **quality gates mínimos de volumen** para aceptar un archivo mensual en el pipeline.
- Los meses anómalos deben ser:
  - excluidos del DW, o  
  - cargados con marca explícita de anomalía, según la política de orquestación.

---

### 3.5 Implicancias para el modelo físico en PostgreSQL

#### 3.5.1 Hallazgo

El análisis técnico recomienda:

- uso de staging previo,
- tipado explícito,
- control de drift de esquema,
- diseño robusto de tipos numéricos y fechas.

Estos puntos se documentan en:

- `postgres_design_notes.md`
- `postgres_recommendations.sql`

#### 3.5.2 Impacto en el diseño

- El modelo físico del DW se implementa en PostgreSQL con:
  - tipos explícitos (`NUMERIC`, `DATE`, `BIGINT`, etc.),
  - claves técnicas surrogate,
  - separación lógica entre staging y DW.
- Estas decisiones se reflejan directamente en `dw_schema.sql`.

---

### 3.6 Trazabilidad y uso futuro

Los hallazgos aquí documentados constituyen la base para:

- la definición de validaciones automáticas en `sql/quality_checks.sql`,
- la orquestación del pipeline en Fase 4 (n8n),
- la justificación de decisiones arquitectónicas en la memoria final del TFM.

Este enfoque asegura que el DW refleje fielmente la realidad de los datos de origen y no un modelo idealizado.

---

## 4. Mapeo CLEAN → DW (columna por columna)

Esta sección documenta el mapeo explícito entre los datasets de la capa `02_CLEAN` del Data Lake y las tablas del Data Warehouse (DW) v1.  
El objetivo es asegurar trazabilidad completa entre columnas de origen y atributos del modelo dimensional.

---

### 4.1 Mapeo CLEAN LIC → `dw.fact_licitaciones`

**Fuente:**

- Ruta: `${DATA_LAKE_ROOT}/02_CLEAN/LIC/manual_csv/`
- Patrón: `lic_YYYY-MM.parquet`

| Columna CLEAN LIC   | Tipo CLEAN     | Destino DW       | Columna DW           | Regla de transformación                 |
|---------------------|----------------|------------------|----------------------|-----------------------------------------|
| CodigoLicitacion    | CodigoExterno  | TEXT             | licitacion_bk        | Copia directa                           |
| FechaPublicacion    | DATE/TIMESTAMP | DIM_FECHA        | fecha_publicacion_sk | Lookup en `dim_fecha`                   |
| FechaCierre         | DATE/TIMESTAMP | DIM_FECHA        | fecha_cierre_sk      | Lookup en `dim_fecha`, null si inválida |
| CodigoOrganismo     | TEXT           | DIM_ORGANISMO    | organismo_sk         | Lookup por código observado             |
| CodigoProveedor     | TEXT           | DIM_PROVEEDOR    | proveedor_sk         | Lookup, null si no adjudicada           |
| CodigoONU           | TEXT           | DIM_PRODUCTO_ONU | producto_onu_sk      | Lookup, null si no aplica               |
| MontoEstimado       | NUMERIC        | FACT             | monto_estimado       | Copia directa                           |
| MontoAdjudicado     | NUMERIC        | FACT             | monto_adjudicado     | Copia directa                           |
| CantidadOferentes   | INTEGER        | FACT             | cantidad_oferentes   | Copia directa                           |
| EstadoLicitacion    | TEXT           | FACT             | estado_licitacion    | Normalización mínima                    |
| TipoAdquisicion     | TEXT           | FACT             | tipo_adquisicion     | Copia directa                           |
| Moneda              | TEXT           | FACT             | moneda               | Copia directa                           |
| YYYY-MM (derivado)  | TEXT           | FACT             | periodo              | Derivado del archivo                    |
| nombre_archivo      | TEXT           | FACT             | source_file          | Opcional                                |
| timestamp_carga     | TIMESTAMP      | FACT             | ingested_at          | `NOW()`                                 |

---

### 4.2 Mapeo CLEAN OC → `dw.fact_ordenes_compra`

**Fuente:**

- Ruta: `${DATA_LAKE_ROOT}/02_CLEAN/OC/manual_csv/`
- Patrón: `oc_YYYY-MM.parquet`

| Columna CLEAN OC   | Tipo CLEAN      | Destino DW       | Columna DW          | Regla de transformación   |
|--------------------|-----------------|------------------|---------------------|---------------------------|
| CodigoOC           | NumeroOrden     | TEXT             | orden_compra_bk     | Copia directa             |
| FechaCreacion      | DATE/TIMESTAMP  | DIM_FECHA        | fecha_creacion_sk   | Lookup                    |
| FechaAceptacion    | DATE/TIMESTAMP  | DIM_FECHA        | fecha_aceptacion_sk | Lookup, null si no existe |
| CodigoOrganismo    | TEXT            | DIM_ORGANISMO    | organismo_sk        | Lookup                    |
| CodigoProveedor    | TEXT            | DIM_PROVEEDOR    | proveedor_sk        | Lookup                    |
| CodigoONU          | TEXT            | DIM_PRODUCTO_ONU | producto_onu_sk     | Lookup                    |
| MontoTotal         | NUMERIC         | FACT             | monto_total         | Copia directa             |
| CantidadTotal      | NUMERIC         | FACT             | cantidad_total      | Copia directa             |
| CantidadItems      | INTEGER         | FACT             | cantidad_items      | Copia directa             |
| EstadoOC           | TEXT            | FACT             | estado_oc           | Normalización mínima      |
| TipoOC             | TEXT            | FACT             | tipo_oc             | Copia directa             |
| Moneda             | TEXT            | FACT             | moneda              | Copia directa             |
| YYYY-MM (derivado) | TEXT            | FACT             | periodo             | Derivado del archivo      |
| nombre_archivo     | TEXT            | FACT             | source_file         | Opcional                  |
| timestamp_carga    | TIMESTAMP       | FACT             | ingested_at         | `NOW()`                   |

---

### 4.3 Mapeo CLEAN → DIMs (reglas comunes)

- `dim_fecha`:
  - Se genera previamente con calendario completo.
  - Todas las fechas CLEAN se resuelven vía lookup.
- `dim_organismo`:
  - Se puebla desde códigos observados en LIC/OC.
  - El maestro oficial se usa solo para enriquecimiento.
- `dim_proveedor`:
  - Clave natural: `codigo_proveedor`.
  - Nombre sujeto a normalización.
- `dim_producto_onu`:
  - Clave natural: `codigo_onu`.
  - Jerarquía ONU si está disponible en metadata.

---

### 4.4 Reglas generales de mapeo

- Campos no presentes en CLEAN → FK null.
- Fechas inválidas → FK null (o registro `unknown` si se define).
- El DW no corrige datos: **asume CLEAN validado**.
- Toda columna DW tiene trazabilidad a CLEAN documentada aquí.

### 4.5 Columnas CLEAN no incorporadas al DW v1

Los datasets de la capa `02_CLEAN` de ChileCompra contienen un número elevado de columnas
(>100 en LIC y ~75 en OC), documentadas exhaustivamente en los artefactos de metadata y profiling.

La **no inclusión** de determinadas columnas en el DW v1 es una decisión **consciente y justificada**, basada en criterios de modelado dimensional y valor analítico.

Las columnas CLEAN excluidas del DW v1 corresponden principalmente a:

- campos textuales de alta cardinalidad sin uso analítico directo,
- atributos puramente descriptivos u operacionales,
- flags técnicos del proceso de compra,
- columnas redundantes o derivables a partir de otras,
- campos con presencia marginal o alta proporción de valores nulos,
- atributos específicos de contexto que no participan en análisis agregados.

La **lista completa de columnas CLEAN**, junto con sus tipos, cardinalidades, porcentaje de nulos y anomalías observadas, se encuentra documentada en:

- `${DATA_LAKE_ROOT}/04_Metadata/schemas/schema_lic_clean_any.csv`
- `${DATA_LAKE_ROOT}/04_Metadata/schemas/schema_oc_clean_any.csv`
- `docs/metada/summary_master_v2.md`

Estas fuentes constituyen la **fuente de verdad de metadata observacional**, mientras que el presente rulebook documenta exclusivamente las columnas que participan en el modelo dimensional del DW v1.
