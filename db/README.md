
# TFM — Diseño e implementación de un sistema ETL automatizado para la integración y análisis de datos abiertos de contratación pública

**Trabajo Fin de Máster — Máster en Data Science e Inteligencia Artificial**

---

## Módulo `db/` — Base de Datos del Data Warehouse

## 1. Propósito del módulo

El directorio `db/` contiene la definición física, versionada y reproducible del modelo de datos implementado en el Data Warehouse (DW) del proyecto *ChileCompra Data Platform*.

Este módulo constituye la fuente oficial de la estructura analítica del sistema y formaliza como código ejecutable:

- La definición de schemas.
- Las tablas dimensionales y de hechos.
- Las restricciones de integridad.
- Los seeds estructurales.
- La capa semántica consumida por Power BI.

El objetivo principal es garantizar que la base de datos pueda reconstruirse completamente desde cero, sin depender del estado persistente de contenedores Docker ni de intervenciones manuales realizadas durante el desarrollo.

---

## 2. Principio de reconstrucción automática

La inicialización del Data Warehouse se realiza mediante el mecanismo estándar del contenedor oficial de PostgreSQL.

En el archivo `docker-compose.yml` se monta:

    ./db/init:/docker-entrypoint-initdb.d:ro

Al ejecutar:

    docker compose down -v
    docker compose up -d

PostgreSQL ejecuta automáticamente todos los scripts ubicados en `db/init/`, recreando:

- Schemas (`stg`, `dw`, `dw_sem`)
- Tablas dimensionales y de hechos
- Seeds obligatorios (ej. `dim_fecha`)
- Vistas semánticas
- Índices y constraints
- Permisos y validaciones

De esta forma, el modelo de datos no depende del estado previo del volumen.

---

## 3. Terminología clave

**ETL (Extract, Transform, Load):**  
Proceso mediante el cual los datos se extraen desde la fuente externa, se transforman conforme a reglas de negocio y se cargan en el Data Warehouse.

**Staging (`stg`):**  
Zona intermedia donde se almacenan temporalmente los datos por período mensual. Permite auditoría y reprocesamiento controlado.

**Gate 2:**  
Etapa del ETL encargada de transformar y cargar dimensiones (organismos, proveedores, productos, calendario). Se generan claves sustitutas y se normalizan registros.

**Gate 3:**  
Etapa del ETL responsable de construir las tablas de hechos, integrando datos transformados con las dimensiones previamente creadas.

**Capa semántica (`dw_sem`):**  
Conjunto de vistas que simplifican el modelo dimensional y actúan como contrato estable para Power BI.

**Pruning:**  
Eliminación de contenedores y volúmenes Docker. Si la estructura no está versionada como código, puede perderse completamente.

---

## 4. Estructura canónica del módulo

    db/
    └── init/
        ├── 00_pre.sql
        ├── 10_dw_schema.sql
        ├── 20_dw_seeds.sql
        ├── 25_stg_audit_views.sql
        ├── 30_dw_sem_views.sql
        ├── 40_indexes.sql
        ├── 90_grants.sql
        └── 99_quality_gates.sql

El orden numérico garantiza ejecución determinística durante la inicialización.

---

## 5. Organización por capas

La arquitectura del Data Warehouse se estructura en tres schemas diferenciados:

- `stg` → Staging mensual por período.
- `dw` → Modelo dimensional persistente.
- `dw_sem` → Capa semántica para consumo analítico.

El schema `public` no contiene tablas de staging ni objetos analíticos.

---

## 6. Modelo dimensional (`dw`)

El schema `dw` contiene:

**Dimensiones:**

- `dim_organismo`
- `dim_fecha`
- `dim_proveedor`
- `dim_producto_onu`

**Hechos:**

- `fact_licitaciones`
- `fact_ordenes_compra`

Se implementan claves sustitutas (`*_sk`), restricciones PK/FK e índices para optimización analítica.

---

## 7. Dimensión calendario

La tabla `dw.dim_fecha` se siembra automáticamente mediante `20_dw_seeds.sql`.

Características:

- Rango controlado (2022–2027)
- Inserción idempotente
- Constraint `UNIQUE(fecha)`

Esto elimina dependencia operativa del ETL para su creación.

---

## 8. Capa semántica (`dw_sem`)

El schema `dw_sem` contiene vistas que actúan como contrato estable para Power BI:

- `v_dim_organismo_sem_v2`
- `v_fact_licitaciones_sem_v2`
- `v_fact_ordenes_compra_sem_v2`

Power BI consume exclusivamente objetos de `dw` y `dw_sem`, garantizando estabilidad ante ajustes internos del modelo.

---

## 9. Quality Gates

El archivo `99_quality_gates.sql` valida:

- Existencia de schemas requeridos.
- Existencia de vistas `_sem_v2`.
- Conteo mínimo en `dim_fecha`.
- Integridad estructural básica.

Estas validaciones evitan inicializaciones parciales o entornos inconsistentes.

---

## 10. Flujo general del sistema

    ETL → STG → DW → SEM → BI

La herramienta BI no depende directamente del staging.

---

## 11. Buenas prácticas y restricciones

No se debe:

- Crear tablas manualmente desde pgAdmin.
- Utilizar el schema `public` para staging.
- Modificar vistas `dw_sem` manualmente en producción.
- Depender de dumps históricos como fuente estructural.
- Ejecutar scripts `.sh` para crear la estructura del DW.

---

## 12. Conclusión

El módulo `db/` formaliza el Data Warehouse como código versionado y reproducible.

Su diseño:

- Garantiza reconstrucción completa tras pruning.
- Se alinea con principios de ingeniería de datos moderna.
- Desacopla almacenamiento, transformación y consumo.
- Formaliza el contrato analítico con Power BI.
- Responde a criterios de gobernanza y trazabilidad académica.
