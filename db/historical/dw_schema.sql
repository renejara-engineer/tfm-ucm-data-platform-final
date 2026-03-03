-- ============================================================
-- TFM – ChileCompra Data Platform (UCM)
-- DW Schema v1 – PostgreSQL 15
-- Archivo: db/dw_schema.sql
-- ============================================================

BEGIN;

-- 0) Esquema DW
CREATE SCHEMA IF NOT EXISTS dw;

-- ------------------------------------------------------------
-- 1) DIMENSIONES
-- ------------------------------------------------------------

-- 1.1 dim_fecha
CREATE TABLE IF NOT EXISTS dw.dim_fecha (
    fecha_sk            INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fecha               DATE NOT NULL,
    anio                SMALLINT,
    mes                 SMALLINT,
    dia                 SMALLINT,
    trimestre           SMALLINT,
    nombre_mes          TEXT,
    nombre_dia_semana   TEXT,
    es_fin_de_semana    BOOLEAN
);

-- Unicidad de fecha natural (calendario)
CREATE UNIQUE INDEX IF NOT EXISTS ux_dim_fecha_fecha
    ON dw.dim_fecha(fecha);

-- 1.2 dim_organismo
CREATE TABLE IF NOT EXISTS dw.dim_organismo (
    organismo_sk        INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo_organismo    TEXT NOT NULL,
    nombre_organismo    TEXT,
    rut_organismo       TEXT,
    region_organismo    TEXT,
    comuna_organismo    TEXT,
    tipo_organismo      TEXT,
    es_organismo_valido BOOLEAN NOT NULL DEFAULT FALSE,
    fuente_preferente   TEXT
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_dim_organismo_codigo
    ON dw.dim_organismo(codigo_organismo);

-- 1.3 dim_proveedor
CREATE TABLE IF NOT EXISTS dw.dim_proveedor (
    proveedor_sk        INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo_proveedor    TEXT NOT NULL,
    rut_proveedor       TEXT,
    nombre_proveedor    TEXT,
    region_proveedor    TEXT,
    comuna_proveedor    TEXT,
    tipo_proveedor      TEXT,
    es_proveedor_activo BOOLEAN,
    fuente_preferente   TEXT
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_dim_proveedor_codigo
    ON dw.dim_proveedor(codigo_proveedor);

-- 1.4 dim_producto_onu
CREATE TABLE IF NOT EXISTS dw.dim_producto_onu (
    producto_onu_sk         INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo_producto_onu     TEXT NOT NULL,
    descripcion_producto_onu TEXT,
    rubro_n1                TEXT,
    rubro_n2                TEXT,
    rubro_n3                TEXT,
    unidad_medida           TEXT,
    es_producto_valido      BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_dim_producto_onu_codigo
    ON dw.dim_producto_onu(codigo_producto_onu);

-- ------------------------------------------------------------
-- 2) HECHOS
-- ------------------------------------------------------------

-- 2.1 fact_licitaciones
CREATE TABLE IF NOT EXISTS dw.fact_licitaciones (
    licitacion_sk        BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    -- Clave natural / trazabilidad
    licitacion_bk        TEXT NOT NULL,

    -- FKs a dimensiones (nullable por datos incompletos)
    fecha_publicacion_sk INTEGER,
    fecha_cierre_sk      INTEGER,
    organismo_sk         INTEGER,
    proveedor_sk         INTEGER,
    producto_onu_sk      INTEGER,

    -- Medidas
    monto_estimado       NUMERIC(18,2),
    monto_adjudicado     NUMERIC(18,2),
    cantidad_oferentes   INTEGER,
    cantidad_items       INTEGER,

    -- Atributos de estado / filtros
    estado_licitacion    TEXT,
    tipo_adquisicion     TEXT,
    moneda               TEXT,

    -- Trazabilidad operacional
    periodo              TEXT NOT NULL,     -- 'YYYY-MM'
    source_file          TEXT,
    ingested_at          TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Índices para consultas típicas
CREATE INDEX IF NOT EXISTS ix_fact_lic_periodo
    ON dw.fact_licitaciones(periodo);

CREATE INDEX IF NOT EXISTS ix_fact_lic_org
    ON dw.fact_licitaciones(organismo_sk);

CREATE INDEX IF NOT EXISTS ix_fact_lic_prov
    ON dw.fact_licitaciones(proveedor_sk);

CREATE INDEX IF NOT EXISTS ix_fact_lic_prod
    ON dw.fact_licitaciones(producto_onu_sk);

CREATE INDEX IF NOT EXISTS ix_fact_lic_fpub
    ON dw.fact_licitaciones(fecha_publicacion_sk);

-- Unicidad de BK por periodo (idempotencia mensual)
CREATE UNIQUE INDEX IF NOT EXISTS ux_fact_lic_bk_periodo
    ON dw.fact_licitaciones(licitacion_bk, periodo);

-- FKs
ALTER TABLE dw.fact_licitaciones
    ADD CONSTRAINT fk_fact_lic_fecha_publicacion
    FOREIGN KEY (fecha_publicacion_sk) REFERENCES dw.dim_fecha(fecha_sk);

ALTER TABLE dw.fact_licitaciones
    ADD CONSTRAINT fk_fact_lic_fecha_cierre
    FOREIGN KEY (fecha_cierre_sk) REFERENCES dw.dim_fecha(fecha_sk);

ALTER TABLE dw.fact_licitaciones
    ADD CONSTRAINT fk_fact_lic_organismo
    FOREIGN KEY (organismo_sk) REFERENCES dw.dim_organismo(organismo_sk);

ALTER TABLE dw.fact_licitaciones
    ADD CONSTRAINT fk_fact_lic_proveedor
    FOREIGN KEY (proveedor_sk) REFERENCES dw.dim_proveedor(proveedor_sk);

ALTER TABLE dw.fact_licitaciones
    ADD CONSTRAINT fk_fact_lic_producto
    FOREIGN KEY (producto_onu_sk) REFERENCES dw.dim_producto_onu(producto_onu_sk);

-- 2.2 fact_ordenes_compra
CREATE TABLE IF NOT EXISTS dw.fact_ordenes_compra (
    orden_compra_sk     BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    -- Clave natural / trazabilidad
    orden_compra_bk     TEXT NOT NULL,

    -- FKs a dimensiones
    fecha_creacion_sk   INTEGER,
    fecha_aceptacion_sk INTEGER,
    organismo_sk        INTEGER,
    proveedor_sk        INTEGER,
    producto_onu_sk     INTEGER,

    -- Medidas
    monto_total         NUMERIC(18,2),
    cantidad_total      NUMERIC(18,2),
    cantidad_items      INTEGER,

    -- Atributos de estado / filtros
    estado_oc           TEXT,
    tipo_oc             TEXT,
    moneda              TEXT,

    -- Trazabilidad
    periodo             TEXT NOT NULL,
    source_file         TEXT,
    ingested_at         TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS ix_fact_oc_periodo
    ON dw.fact_ordenes_compra(periodo);

CREATE INDEX IF NOT EXISTS ix_fact_oc_org
    ON dw.fact_ordenes_compra(organismo_sk);

CREATE INDEX IF NOT EXISTS ix_fact_oc_prov
    ON dw.fact_ordenes_compra(proveedor_sk);

CREATE INDEX IF NOT EXISTS ix_fact_oc_prod
    ON dw.fact_ordenes_compra(producto_onu_sk);

CREATE INDEX IF NOT EXISTS ix_fact_oc_fcrea
    ON dw.fact_ordenes_compra(fecha_creacion_sk);

CREATE UNIQUE INDEX IF NOT EXISTS ux_fact_oc_bk_periodo
    ON dw.fact_ordenes_compra(orden_compra_bk, periodo);

ALTER TABLE dw.fact_ordenes_compra
    ADD CONSTRAINT fk_fact_oc_fecha_creacion
    FOREIGN KEY (fecha_creacion_sk) REFERENCES dw.dim_fecha(fecha_sk);

ALTER TABLE dw.fact_ordenes_compra
    ADD CONSTRAINT fk_fact_oc_fecha_aceptacion
    FOREIGN KEY (fecha_aceptacion_sk) REFERENCES dw.dim_fecha(fecha_sk);

ALTER TABLE dw.fact_ordenes_compra
    ADD CONSTRAINT fk_fact_oc_organismo
    FOREIGN KEY (organismo_sk) REFERENCES dw.dim_organismo(organismo_sk);

ALTER TABLE dw.fact_ordenes_compra
    ADD CONSTRAINT fk_fact_oc_proveedor
    FOREIGN KEY (proveedor_sk) REFERENCES dw.dim_proveedor(proveedor_sk);

ALTER TABLE dw.fact_ordenes_compra
    ADD CONSTRAINT fk_fact_oc_producto
    FOREIGN KEY (producto_onu_sk) REFERENCES dw.dim_producto_onu(producto_onu_sk);

COMMIT;
