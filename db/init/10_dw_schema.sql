\set ON_ERROR_STOP on

-- Name: dw; Type: SCHEMA; Schema: -; Owner: chile_user
--

CREATE SCHEMA IF NOT EXISTS dw;


ALTER SCHEMA dw OWNER TO chile_user;

--

-- Name: dim_fecha; Type: TABLE; Schema: dw; Owner: chile_user
--

CREATE TABLE dw.dim_fecha (
    fecha_sk integer NOT NULL,
    fecha date NOT NULL,
    anio smallint,
    mes smallint,
    dia smallint,
    trimestre smallint,
    nombre_mes text,
    nombre_dia_semana text,
    es_fin_de_semana boolean
);


ALTER TABLE dw.dim_fecha OWNER TO chile_user;

--

-- Name: dim_fecha_fecha_sk_seq; Type: SEQUENCE; Schema: dw; Owner: chile_user
--

ALTER TABLE dw.dim_fecha ALTER COLUMN fecha_sk ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dw.dim_fecha_fecha_sk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: dim_organismo; Type: TABLE; Schema: dw; Owner: chile_user
--

CREATE TABLE dw.dim_organismo (
    organismo_sk integer NOT NULL,
    codigo_organismo text NOT NULL,
    nombre_organismo text,
    rut_organismo text,
    region_organismo text,
    comuna_organismo text,
    tipo_organismo text,
    es_organismo_valido boolean DEFAULT false NOT NULL,
    fuente_preferente text
);


ALTER TABLE dw.dim_organismo OWNER TO chile_user;

--

-- Name: dim_organismo_organismo_sk_seq; Type: SEQUENCE; Schema: dw; Owner: chile_user
--

ALTER TABLE dw.dim_organismo ALTER COLUMN organismo_sk ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dw.dim_organismo_organismo_sk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: dim_producto_onu; Type: TABLE; Schema: dw; Owner: chile_user
--

CREATE TABLE dw.dim_producto_onu (
    producto_onu_sk integer NOT NULL,
    codigo_producto_onu text NOT NULL,
    descripcion_producto_onu text,
    rubro_n1 text,
    rubro_n2 text,
    rubro_n3 text,
    unidad_medida text,
    es_producto_valido boolean DEFAULT false NOT NULL
);


ALTER TABLE dw.dim_producto_onu OWNER TO chile_user;

--

-- Name: dim_producto_onu_producto_onu_sk_seq; Type: SEQUENCE; Schema: dw; Owner: chile_user
--

ALTER TABLE dw.dim_producto_onu ALTER COLUMN producto_onu_sk ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dw.dim_producto_onu_producto_onu_sk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: dim_proveedor; Type: TABLE; Schema: dw; Owner: chile_user
--

CREATE TABLE dw.dim_proveedor (
    proveedor_sk integer NOT NULL,
    codigo_proveedor text NOT NULL,
    rut_proveedor text,
    nombre_proveedor text,
    region_proveedor text,
    comuna_proveedor text,
    tipo_proveedor text,
    es_proveedor_activo boolean,
    fuente_preferente text
);


ALTER TABLE dw.dim_proveedor OWNER TO chile_user;

--

-- Name: dim_proveedor_proveedor_sk_seq; Type: SEQUENCE; Schema: dw; Owner: chile_user
--

ALTER TABLE dw.dim_proveedor ALTER COLUMN proveedor_sk ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dw.dim_proveedor_proveedor_sk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: etl_control_cargas; Type: TABLE; Schema: dw; Owner: chile_user
--

CREATE TABLE dw.etl_control_cargas (
    entidad text NOT NULL,
    periodo text NOT NULL,
    estado text NOT NULL,
    archivo text,
    filas_stg integer,
    filas_dw integer,
    ts_inicio timestamp with time zone DEFAULT now() NOT NULL,
    ts_fin timestamp with time zone,
    error_msg text
);


ALTER TABLE dw.etl_control_cargas OWNER TO chile_user;

--

-- Name: etl_decisiones_periodo; Type: TABLE; Schema: dw; Owner: chile_user
--

CREATE TABLE dw.etl_decisiones_periodo (
    periodo text NOT NULL,
    decision text NOT NULL,
    reason_code text,
    reason_text text,
    lic_file text,
    oc_file text,
    lic_cols integer,
    oc_bytes bigint,
    oc_lines integer,
    ts timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE dw.etl_decisiones_periodo OWNER TO chile_user;

--

-- Name: fact_licitaciones; Type: TABLE; Schema: dw; Owner: chile_user
--

CREATE TABLE dw.fact_licitaciones (
    licitacion_sk bigint NOT NULL,
    licitacion_bk text NOT NULL,
    fecha_publicacion_sk integer,
    fecha_cierre_sk integer,
    organismo_sk integer,
    proveedor_sk integer,
    producto_onu_sk integer,
    monto_estimado numeric(18,2),
    monto_adjudicado numeric(18,2),
    cantidad_oferentes integer,
    cantidad_items integer,
    estado_licitacion text,
    tipo_adquisicion text,
    moneda text,
    periodo text NOT NULL,
    source_file text,
    ingested_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE dw.fact_licitaciones OWNER TO chile_user;

--

-- Name: fact_licitaciones_licitacion_sk_seq; Type: SEQUENCE; Schema: dw; Owner: chile_user
--

ALTER TABLE dw.fact_licitaciones ALTER COLUMN licitacion_sk ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dw.fact_licitaciones_licitacion_sk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: fact_ordenes_compra; Type: TABLE; Schema: dw; Owner: chile_user
--

CREATE TABLE dw.fact_ordenes_compra (
    orden_compra_sk bigint NOT NULL,
    orden_compra_bk text NOT NULL,
    fecha_creacion_sk integer,
    fecha_aceptacion_sk integer,
    organismo_sk integer,
    proveedor_sk integer,
    producto_onu_sk integer,
    monto_total numeric(18,2),
    cantidad_total numeric(18,2),
    cantidad_items integer,
    estado_oc text,
    tipo_oc text,
    moneda text,
    periodo text NOT NULL,
    source_file text,
    ingested_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE dw.fact_ordenes_compra OWNER TO chile_user;

--

-- Name: fact_ordenes_compra_orden_compra_sk_seq; Type: SEQUENCE; Schema: dw; Owner: chile_user
--

ALTER TABLE dw.fact_ordenes_compra ALTER COLUMN orden_compra_sk ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dw.fact_ordenes_compra_orden_compra_sk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: dim_fecha dim_fecha_pkey; Type: CONSTRAINT; Schema: dw; Owner: chile_user
--

ALTER TABLE ONLY dw.dim_fecha
    ADD CONSTRAINT dim_fecha_pkey PRIMARY KEY (fecha_sk);




ALTER TABLE ONLY dw.dim_fecha
    ADD CONSTRAINT uq_dim_fecha_fecha UNIQUE (fecha);
--

-- Name: dim_organismo dim_organismo_pkey; Type: CONSTRAINT; Schema: dw; Owner: chile_user
--

ALTER TABLE ONLY dw.dim_organismo
    ADD CONSTRAINT dim_organismo_pkey PRIMARY KEY (organismo_sk);


--

-- Name: dim_producto_onu dim_producto_onu_pkey; Type: CONSTRAINT; Schema: dw; Owner: chile_user
--

ALTER TABLE ONLY dw.dim_producto_onu
    ADD CONSTRAINT dim_producto_onu_pkey PRIMARY KEY (producto_onu_sk);


--

-- Name: dim_proveedor dim_proveedor_pkey; Type: CONSTRAINT; Schema: dw; Owner: chile_user
--

ALTER TABLE ONLY dw.dim_proveedor
    ADD CONSTRAINT dim_proveedor_pkey PRIMARY KEY (proveedor_sk);


--

-- Name: etl_control_cargas etl_control_cargas_pkey; Type: CONSTRAINT; Schema: dw; Owner: chile_user
--

ALTER TABLE ONLY dw.etl_control_cargas
    ADD CONSTRAINT etl_control_cargas_pkey PRIMARY KEY (entidad, periodo);


--

-- Name: etl_decisiones_periodo etl_decisiones_periodo_pkey; Type: CONSTRAINT; Schema: dw; Owner: chile_user
--

ALTER TABLE ONLY dw.etl_decisiones_periodo
    ADD CONSTRAINT etl_decisiones_periodo_pkey PRIMARY KEY (periodo);


--

-- Name: fact_licitaciones fact_licitaciones_pkey; Type: CONSTRAINT; Schema: dw; Owner: chile_user
--

ALTER TABLE ONLY dw.fact_licitaciones
    ADD CONSTRAINT fact_licitaciones_pkey PRIMARY KEY (licitacion_sk);


--

-- Name: fact_ordenes_compra fact_ordenes_compra_pkey; Type: CONSTRAINT; Schema: dw; Owner: chile_user
--

ALTER TABLE ONLY dw.fact_ordenes_compra
    ADD CONSTRAINT fact_ordenes_compra_pkey PRIMARY KEY (orden_compra_sk);


--

-- Name: fact_licitaciones fk_fact_lic_fecha_cierre; Type: FK CONSTRAINT; Schema: dw; Owner: chile_user
--

ALTER TABLE ONLY dw.fact_licitaciones
    ADD CONSTRAINT fk_fact_lic_fecha_cierre FOREIGN KEY (fecha_cierre_sk) REFERENCES dw.dim_fecha(fecha_sk);


--

-- Name: fact_licitaciones fk_fact_lic_fecha_publicacion; Type: FK CONSTRAINT; Schema: dw; Owner: chile_user
--

ALTER TABLE ONLY dw.fact_licitaciones
    ADD CONSTRAINT fk_fact_lic_fecha_publicacion FOREIGN KEY (fecha_publicacion_sk) REFERENCES dw.dim_fecha(fecha_sk);


--

-- Name: fact_licitaciones fk_fact_lic_organismo; Type: FK CONSTRAINT; Schema: dw; Owner: chile_user
--

ALTER TABLE ONLY dw.fact_licitaciones
    ADD CONSTRAINT fk_fact_lic_organismo FOREIGN KEY (organismo_sk) REFERENCES dw.dim_organismo(organismo_sk);


--

-- Name: fact_licitaciones fk_fact_lic_producto; Type: FK CONSTRAINT; Schema: dw; Owner: chile_user
--

ALTER TABLE ONLY dw.fact_licitaciones
    ADD CONSTRAINT fk_fact_lic_producto FOREIGN KEY (producto_onu_sk) REFERENCES dw.dim_producto_onu(producto_onu_sk);


--

-- Name: fact_licitaciones fk_fact_lic_proveedor; Type: FK CONSTRAINT; Schema: dw; Owner: chile_user
--

ALTER TABLE ONLY dw.fact_licitaciones
    ADD CONSTRAINT fk_fact_lic_proveedor FOREIGN KEY (proveedor_sk) REFERENCES dw.dim_proveedor(proveedor_sk);


--

-- Name: fact_ordenes_compra fk_fact_oc_fecha_aceptacion; Type: FK CONSTRAINT; Schema: dw; Owner: chile_user
--

ALTER TABLE ONLY dw.fact_ordenes_compra
    ADD CONSTRAINT fk_fact_oc_fecha_aceptacion FOREIGN KEY (fecha_aceptacion_sk) REFERENCES dw.dim_fecha(fecha_sk);


--

-- Name: fact_ordenes_compra fk_fact_oc_fecha_creacion; Type: FK CONSTRAINT; Schema: dw; Owner: chile_user
--

ALTER TABLE ONLY dw.fact_ordenes_compra
    ADD CONSTRAINT fk_fact_oc_fecha_creacion FOREIGN KEY (fecha_creacion_sk) REFERENCES dw.dim_fecha(fecha_sk);


--

-- Name: fact_ordenes_compra fk_fact_oc_organismo; Type: FK CONSTRAINT; Schema: dw; Owner: chile_user
--

ALTER TABLE ONLY dw.fact_ordenes_compra
    ADD CONSTRAINT fk_fact_oc_organismo FOREIGN KEY (organismo_sk) REFERENCES dw.dim_organismo(organismo_sk);


--

-- Name: fact_ordenes_compra fk_fact_oc_producto; Type: FK CONSTRAINT; Schema: dw; Owner: chile_user
--

ALTER TABLE ONLY dw.fact_ordenes_compra
    ADD CONSTRAINT fk_fact_oc_producto FOREIGN KEY (producto_onu_sk) REFERENCES dw.dim_producto_onu(producto_onu_sk);


--

-- Name: fact_ordenes_compra fk_fact_oc_proveedor; Type: FK CONSTRAINT; Schema: dw; Owner: chile_user
--

ALTER TABLE ONLY dw.fact_ordenes_compra
    ADD CONSTRAINT fk_fact_oc_proveedor FOREIGN KEY (proveedor_sk) REFERENCES dw.dim_proveedor(proveedor_sk);


--

-- -----------------------------------------------------------------------------
-- Uniqueness constraints required for ETL UPSERT (ON CONFLICT)
-- -----------------------------------------------------------------------------
ALTER TABLE dw.dim_organismo
  ADD CONSTRAINT uq_dim_organismo_codigo UNIQUE (codigo_organismo);

ALTER TABLE dw.dim_proveedor
  ADD CONSTRAINT uq_dim_proveedor_codigo UNIQUE (codigo_proveedor);

ALTER TABLE dw.dim_producto_onu
  ADD CONSTRAINT uq_dim_producto_onu_codigo UNIQUE (codigo_producto_onu);

ALTER TABLE dw.fact_licitaciones
  ADD CONSTRAINT uq_fact_licitaciones_bk_periodo UNIQUE (licitacion_bk, periodo);

ALTER TABLE dw.fact_ordenes_compra
  ADD CONSTRAINT uq_fact_oc_bk_periodo UNIQUE (orden_compra_bk, periodo);
-- PostgreSQL database dump complete
--
