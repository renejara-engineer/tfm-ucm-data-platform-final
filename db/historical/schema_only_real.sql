--
-- PostgreSQL database dump
--

\restrict sgyuOq0ekyt9aZU9ulWfVL8sCWy1l1h5YcoV4DHzFDBBSK8NmQf7rhEK85uqO5f

-- Dumped from database version 15.14
-- Dumped by pg_dump version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: dw; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA dw;


--
-- Name: dw_sem; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA dw_sem;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dim_fecha; Type: TABLE; Schema: dw; Owner: -
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


--
-- Name: dim_fecha_fecha_sk_seq; Type: SEQUENCE; Schema: dw; Owner: -
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
-- Name: dim_organismo; Type: TABLE; Schema: dw; Owner: -
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


--
-- Name: dim_organismo_organismo_sk_seq; Type: SEQUENCE; Schema: dw; Owner: -
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
-- Name: dim_producto_onu; Type: TABLE; Schema: dw; Owner: -
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


--
-- Name: dim_producto_onu_producto_onu_sk_seq; Type: SEQUENCE; Schema: dw; Owner: -
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
-- Name: dim_proveedor; Type: TABLE; Schema: dw; Owner: -
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


--
-- Name: dim_proveedor_proveedor_sk_seq; Type: SEQUENCE; Schema: dw; Owner: -
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
-- Name: etl_control_cargas; Type: TABLE; Schema: dw; Owner: -
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


--
-- Name: etl_decisiones_periodo; Type: TABLE; Schema: dw; Owner: -
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


--
-- Name: fact_licitaciones; Type: TABLE; Schema: dw; Owner: -
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


--
-- Name: fact_licitaciones_licitacion_sk_seq; Type: SEQUENCE; Schema: dw; Owner: -
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
-- Name: fact_ordenes_compra; Type: TABLE; Schema: dw; Owner: -
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


--
-- Name: fact_ordenes_compra_orden_compra_sk_seq; Type: SEQUENCE; Schema: dw; Owner: -
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
-- Name: v_dim_organismo_sem_v2; Type: VIEW; Schema: dw_sem; Owner: -
--

CREATE VIEW dw_sem.v_dim_organismo_sem_v2 AS
 SELECT o.organismo_sk,
    o.codigo_organismo,
    o.nombre_organismo,
    o.rut_organismo,
    o.region_organismo,
    o.comuna_organismo,
    o.tipo_organismo,
    o.es_organismo_valido,
    o.fuente_preferente,
    NULLIF(btrim(o.tipo_organismo), ''::text) AS tipo_organismo_raw,
        CASE
            WHEN (NULLIF(btrim(o.tipo_organismo), ''::text) IS NULL) THEN NULL::text
            WHEN (upper(btrim(o.tipo_organismo)) = 'MUNICIPALIDADES'::text) THEN 'MUNICIPALIDADES'::text
            WHEN (upper(btrim(o.tipo_organismo)) = 'SALUD'::text) THEN 'SALUD'::text
            WHEN (upper(btrim(o.tipo_organismo)) = 'GOB. CENTRAL, UNIVERSIDADES'::text) THEN 'GOB_CENTRAL_UNIVERSIDADES'::text
            WHEN (upper(btrim(o.tipo_organismo)) = 'OTROS'::text) THEN 'OTROS'::text
            WHEN (upper(btrim(o.tipo_organismo)) = 'OBRAS PÚBLICAS'::text) THEN 'OBRAS_PUBLICAS'::text
            WHEN (upper(btrim(o.tipo_organismo)) = 'FFAA'::text) THEN 'FFAA'::text
            WHEN (upper(btrim(o.tipo_organismo)) = 'LEGISLATIVO Y JUDICIAL'::text) THEN 'LEGISLATIVO_JUDICIAL'::text
            ELSE NULL::text
        END AS sector_estado_norm,
        CASE
            WHEN (NULLIF(btrim(o.tipo_organismo), ''::text) IS NULL) THEN 1
            ELSE 0
        END AS flag_sector_missing,
        CASE
            WHEN (NULLIF(btrim(o.tipo_organismo), ''::text) IS NULL) THEN 0
            WHEN (upper(btrim(o.tipo_organismo)) = ANY (ARRAY['MUNICIPALIDADES'::text, 'SALUD'::text, 'GOB. CENTRAL, UNIVERSIDADES'::text, 'OTROS'::text, 'OBRAS PÚBLICAS'::text, 'FFAA'::text, 'LEGISLATIVO Y JUDICIAL'::text])) THEN 0
            ELSE 1
        END AS flag_sector_unknown,
        CASE
            WHEN (o.es_organismo_valido IS TRUE) THEN 1
            ELSE 0
        END AS flag_organismo_valido,
        CASE
            WHEN (NULLIF(btrim(o.fuente_preferente), ''::text) IS NULL) THEN 1
            ELSE 0
        END AS flag_fuente_preferente_missing
   FROM dw.dim_organismo o;


--
-- Name: v_dim_organismo_sem; Type: VIEW; Schema: dw_sem; Owner: -
--

CREATE VIEW dw_sem.v_dim_organismo_sem AS
 SELECT v_dim_organismo_sem_v2.organismo_sk,
    v_dim_organismo_sem_v2.codigo_organismo,
    v_dim_organismo_sem_v2.nombre_organismo,
    v_dim_organismo_sem_v2.rut_organismo,
    v_dim_organismo_sem_v2.region_organismo,
    v_dim_organismo_sem_v2.comuna_organismo,
    v_dim_organismo_sem_v2.tipo_organismo,
    v_dim_organismo_sem_v2.es_organismo_valido,
    v_dim_organismo_sem_v2.fuente_preferente,
    v_dim_organismo_sem_v2.tipo_organismo_raw,
    v_dim_organismo_sem_v2.sector_estado_norm,
    v_dim_organismo_sem_v2.flag_sector_missing,
    v_dim_organismo_sem_v2.flag_sector_unknown,
    v_dim_organismo_sem_v2.flag_organismo_valido,
    v_dim_organismo_sem_v2.flag_fuente_preferente_missing
   FROM dw_sem.v_dim_organismo_sem_v2;


--
-- Name: v_fact_licitaciones_sem; Type: VIEW; Schema: dw_sem; Owner: -
--

CREATE VIEW dw_sem.v_fact_licitaciones_sem AS
 SELECT f.licitacion_sk,
    f.licitacion_bk,
    f.fecha_publicacion_sk,
    f.fecha_cierre_sk,
    f.organismo_sk,
    f.proveedor_sk,
    f.producto_onu_sk,
    f.monto_estimado,
    f.monto_adjudicado,
    f.cantidad_oferentes,
    f.cantidad_items,
    f.estado_licitacion,
    f.tipo_adquisicion,
    f.moneda,
    f.periodo,
    f.source_file,
    f.ingested_at,
    NULLIF(upper(btrim(f.moneda)), ''::text) AS moneda_raw,
        CASE
            WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) = ANY (ARRAY['CLP'::text, 'PESO'::text, 'PESOS'::text, '$'::text, 'PESO CHILENO'::text, 'PESOS CHILENOS'::text, 'PESO CHILENO (CLP)'::text])) THEN 'CLP'::text
            WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) = ANY (ARRAY['USD'::text, 'US$'::text, 'DOLAR'::text, 'DÓLAR'::text, 'DOLLAR'::text, 'DÓLAR (USD)'::text])) THEN 'USD'::text
            WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) = ANY (ARRAY['CLF'::text, 'UF'::text, 'UNIDAD DE FOMENTO'::text, 'UNIDAD DE FOMENTO (UF)'::text])) THEN 'CLF'::text
            WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) = 'UTM'::text) THEN 'UTM'::text
            WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) = ANY (ARRAY['EUR'::text, 'EURO'::text, '€'::text])) THEN 'EUR'::text
            ELSE NULL::text
        END AS moneda_norm,
        CASE
            WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) IS NULL) THEN 1
            ELSE 0
        END AS flag_moneda_missing,
        CASE
            WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) IS NULL) THEN 0
            WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) = ANY (ARRAY['CLP'::text, 'PESO'::text, 'PESOS'::text, '$'::text, 'PESO CHILENO'::text, 'PESOS CHILENOS'::text, 'PESO CHILENO (CLP)'::text, 'USD'::text, 'US$'::text, 'DOLAR'::text, 'DÓLAR'::text, 'DOLLAR'::text, 'DÓLAR (USD)'::text, 'CLF'::text, 'UF'::text, 'UNIDAD DE FOMENTO'::text, 'UNIDAD DE FOMENTO (UF)'::text, 'UTM'::text, 'EUR'::text, 'EURO'::text, '€'::text])) THEN 0
            ELSE 1
        END AS flag_moneda_unknown,
    o.sector_estado_norm,
    o.flag_sector_missing,
    o.flag_sector_unknown,
    o.flag_organismo_valido,
    o.flag_fuente_preferente_missing,
        CASE
            WHEN ((
            CASE
                WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) = ANY (ARRAY['CLP'::text, 'PESO'::text, 'PESOS'::text, '$'::text, 'PESO CHILENO'::text, 'PESOS CHILENOS'::text, 'PESO CHILENO (CLP)'::text])) THEN 'CLP'::text
                WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) = ANY (ARRAY['USD'::text, 'US$'::text, 'DOLAR'::text, 'DÓLAR'::text, 'DOLLAR'::text, 'DÓLAR (USD)'::text])) THEN 'USD'::text
                WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) = ANY (ARRAY['CLF'::text, 'UF'::text, 'UNIDAD DE FOMENTO'::text, 'UNIDAD DE FOMENTO (UF)'::text])) THEN 'CLF'::text
                WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) = 'UTM'::text) THEN 'UTM'::text
                WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) = ANY (ARRAY['EUR'::text, 'EURO'::text, '€'::text])) THEN 'EUR'::text
                ELSE NULL::text
            END = 'CLP'::text) AND (f.monto_estimado IS NOT NULL) AND (f.monto_estimado > ('1000000000000'::bigint)::numeric)) THEN 1
            ELSE 0
        END AS flag_monto_estimado_anom,
        CASE
            WHEN ((
            CASE
                WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) = ANY (ARRAY['CLP'::text, 'PESO'::text, 'PESOS'::text, '$'::text, 'PESO CHILENO'::text, 'PESOS CHILENOS'::text, 'PESO CHILENO (CLP)'::text])) THEN 'CLP'::text
                WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) = ANY (ARRAY['USD'::text, 'US$'::text, 'DOLAR'::text, 'DÓLAR'::text, 'DOLLAR'::text, 'DÓLAR (USD)'::text])) THEN 'USD'::text
                WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) = ANY (ARRAY['CLF'::text, 'UF'::text, 'UNIDAD DE FOMENTO'::text, 'UNIDAD DE FOMENTO (UF)'::text])) THEN 'CLF'::text
                WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) = 'UTM'::text) THEN 'UTM'::text
                WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) = ANY (ARRAY['EUR'::text, 'EURO'::text, '€'::text])) THEN 'EUR'::text
                ELSE NULL::text
            END = 'CLP'::text) AND (f.monto_estimado IS NOT NULL) AND (f.monto_estimado > ('1000000000000'::bigint)::numeric)) THEN NULL::numeric
            ELSE f.monto_estimado
        END AS monto_estimado_norm
   FROM (dw.fact_licitaciones f
     LEFT JOIN dw_sem.v_dim_organismo_sem o ON ((o.organismo_sk = f.organismo_sk)));


--
-- Name: v_fact_licitaciones_sem_v2; Type: VIEW; Schema: dw_sem; Owner: -
--

CREATE VIEW dw_sem.v_fact_licitaciones_sem_v2 AS
 SELECT v_fact_licitaciones_sem.licitacion_sk,
    v_fact_licitaciones_sem.licitacion_bk,
    v_fact_licitaciones_sem.fecha_publicacion_sk,
    v_fact_licitaciones_sem.fecha_cierre_sk,
    v_fact_licitaciones_sem.organismo_sk,
    v_fact_licitaciones_sem.proveedor_sk,
    v_fact_licitaciones_sem.producto_onu_sk,
    v_fact_licitaciones_sem.monto_estimado,
    v_fact_licitaciones_sem.monto_adjudicado,
    v_fact_licitaciones_sem.cantidad_oferentes,
    v_fact_licitaciones_sem.cantidad_items,
    v_fact_licitaciones_sem.estado_licitacion,
    v_fact_licitaciones_sem.tipo_adquisicion,
    v_fact_licitaciones_sem.moneda,
    v_fact_licitaciones_sem.periodo,
    v_fact_licitaciones_sem.source_file,
    v_fact_licitaciones_sem.ingested_at,
    v_fact_licitaciones_sem.moneda_raw,
    v_fact_licitaciones_sem.moneda_norm,
    v_fact_licitaciones_sem.flag_moneda_missing,
    v_fact_licitaciones_sem.flag_moneda_unknown,
    v_fact_licitaciones_sem.sector_estado_norm,
    v_fact_licitaciones_sem.flag_sector_missing,
    v_fact_licitaciones_sem.flag_sector_unknown,
    v_fact_licitaciones_sem.flag_organismo_valido,
    v_fact_licitaciones_sem.flag_fuente_preferente_missing,
    v_fact_licitaciones_sem.flag_monto_estimado_anom,
    v_fact_licitaciones_sem.monto_estimado_norm
   FROM dw_sem.v_fact_licitaciones_sem;


--
-- Name: v_fact_ordenes_compra_sem_v2; Type: VIEW; Schema: dw_sem; Owner: -
--

CREATE VIEW dw_sem.v_fact_ordenes_compra_sem_v2 AS
 SELECT f.orden_compra_sk,
    f.orden_compra_bk,
    f.fecha_creacion_sk,
    f.fecha_aceptacion_sk,
    f.organismo_sk,
    f.proveedor_sk,
    f.producto_onu_sk,
    f.monto_total,
    f.cantidad_total,
    f.cantidad_items,
    f.estado_oc,
    f.tipo_oc,
    f.moneda,
    f.periodo,
    f.source_file,
    f.ingested_at,
    NULLIF(upper(btrim(f.moneda)), ''::text) AS moneda_raw,
        CASE
            WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) = ANY (ARRAY['CLP'::text, 'PESO'::text, 'PESOS'::text, '$'::text, 'PESO CHILENO'::text, 'PESOS CHILENOS'::text, 'PESO CHILENO (CLP)'::text])) THEN 'CLP'::text
            WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) = ANY (ARRAY['USD'::text, 'US$'::text, 'DOLAR'::text, 'DÓLAR'::text, 'DOLLAR'::text, 'DÓLAR (USD)'::text])) THEN 'USD'::text
            WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) = ANY (ARRAY['CLF'::text, 'UF'::text, 'UNIDAD DE FOMENTO'::text, 'UNIDAD DE FOMENTO (UF)'::text])) THEN 'CLF'::text
            WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) = 'UTM'::text) THEN 'UTM'::text
            WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) = ANY (ARRAY['EUR'::text, 'EURO'::text, '€'::text])) THEN 'EUR'::text
            ELSE NULL::text
        END AS moneda_norm,
        CASE
            WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) IS NULL) THEN 1
            ELSE 0
        END AS flag_moneda_missing,
        CASE
            WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) IS NULL) THEN 0
            WHEN (NULLIF(upper(btrim(f.moneda)), ''::text) = ANY (ARRAY['CLP'::text, 'PESO'::text, 'PESOS'::text, '$'::text, 'PESO CHILENO'::text, 'PESOS CHILENOS'::text, 'PESO CHILENO (CLP)'::text, 'USD'::text, 'US$'::text, 'DOLAR'::text, 'DÓLAR'::text, 'DOLLAR'::text, 'DÓLAR (USD)'::text, 'CLF'::text, 'UF'::text, 'UNIDAD DE FOMENTO'::text, 'UNIDAD DE FOMENTO (UF)'::text, 'UTM'::text, 'EUR'::text, 'EURO'::text, '€'::text])) THEN 0
            ELSE 1
        END AS flag_moneda_unknown,
    o.sector_estado_norm,
    o.flag_sector_missing,
    o.flag_sector_unknown,
    o.flag_organismo_valido,
    o.flag_fuente_preferente_missing
   FROM (dw.fact_ordenes_compra f
     LEFT JOIN dw_sem.v_dim_organismo_sem o ON ((o.organismo_sk = f.organismo_sk)));


--
-- Name: v_cruce_lic_oc_lag_v1; Type: VIEW; Schema: dw_sem; Owner: -
--

CREATE VIEW dw_sem.v_cruce_lic_oc_lag_v1 AS
 WITH lic AS (
         SELECT v_fact_licitaciones_sem_v2.periodo,
            v_fact_licitaciones_sem_v2.organismo_sk,
            v_fact_licitaciones_sem_v2.moneda_norm,
            v_fact_licitaciones_sem_v2.sector_estado_norm,
            count(*) AS lic_n,
            sum(v_fact_licitaciones_sem_v2.monto_estimado_norm) AS lic_monto_estimado_norm,
            sum(v_fact_licitaciones_sem_v2.monto_adjudicado) AS lic_monto_adjudicado
           FROM dw_sem.v_fact_licitaciones_sem_v2
          GROUP BY v_fact_licitaciones_sem_v2.periodo, v_fact_licitaciones_sem_v2.organismo_sk, v_fact_licitaciones_sem_v2.moneda_norm, v_fact_licitaciones_sem_v2.sector_estado_norm
        ), oc AS (
         SELECT v_fact_ordenes_compra_sem_v2.periodo,
            v_fact_ordenes_compra_sem_v2.organismo_sk,
            v_fact_ordenes_compra_sem_v2.moneda_norm,
            v_fact_ordenes_compra_sem_v2.sector_estado_norm,
            count(*) AS oc_n,
            sum(v_fact_ordenes_compra_sem_v2.monto_total) AS oc_monto_total
           FROM dw_sem.v_fact_ordenes_compra_sem_v2
          GROUP BY v_fact_ordenes_compra_sem_v2.periodo, v_fact_ordenes_compra_sem_v2.organismo_sk, v_fact_ordenes_compra_sem_v2.moneda_norm, v_fact_ordenes_compra_sem_v2.sector_estado_norm
        ), lags AS (
         SELECT generate_series(0, 12) AS lag_meses
        ), lic_t AS (
         SELECT to_date((lic.periodo || '-01'::text), 'YYYY-MM-DD'::text) AS periodo_dt,
            lic.periodo AS periodo_lic,
            lic.organismo_sk,
            lic.moneda_norm,
            lic.sector_estado_norm,
            lic.lic_n,
            lic.lic_monto_estimado_norm,
            lic.lic_monto_adjudicado
           FROM lic
        ), oc_t AS (
         SELECT to_date((oc.periodo || '-01'::text), 'YYYY-MM-DD'::text) AS periodo_dt,
            oc.periodo AS periodo_oc,
            oc.organismo_sk,
            oc.moneda_norm,
            oc.sector_estado_norm,
            oc.oc_n,
            oc.oc_monto_total
           FROM oc
        )
 SELECT lt.periodo_lic,
    to_char((lt.periodo_dt + ('1 mon'::interval * (l.lag_meses)::double precision)), 'YYYY-MM'::text) AS periodo_oc_esperado,
    l.lag_meses,
    lt.organismo_sk,
    lt.moneda_norm,
    lt.sector_estado_norm,
    lt.lic_n,
    lt.lic_monto_estimado_norm,
    lt.lic_monto_adjudicado,
    COALESCE(ot.oc_n, (0)::bigint) AS oc_n,
    COALESCE(ot.oc_monto_total, (0)::numeric) AS oc_monto_total,
        CASE
            WHEN (COALESCE(ot.oc_n, (0)::bigint) > 0) THEN 1
            ELSE 0
        END AS flag_hay_oc_en_lag
   FROM ((lic_t lt
     CROSS JOIN lags l)
     LEFT JOIN oc_t ot ON (((ot.periodo_dt = (lt.periodo_dt + ('1 mon'::interval * (l.lag_meses)::double precision))) AND (ot.organismo_sk = lt.organismo_sk) AND (ot.moneda_norm = lt.moneda_norm) AND (ot.sector_estado_norm = lt.sector_estado_norm))));


--
-- Name: v_fact_ordenes_compra_sem; Type: VIEW; Schema: dw_sem; Owner: -
--

CREATE VIEW dw_sem.v_fact_ordenes_compra_sem AS
 SELECT v_fact_ordenes_compra_sem_v2.orden_compra_sk,
    v_fact_ordenes_compra_sem_v2.orden_compra_bk,
    v_fact_ordenes_compra_sem_v2.fecha_creacion_sk,
    v_fact_ordenes_compra_sem_v2.fecha_aceptacion_sk,
    v_fact_ordenes_compra_sem_v2.organismo_sk,
    v_fact_ordenes_compra_sem_v2.proveedor_sk,
    v_fact_ordenes_compra_sem_v2.producto_onu_sk,
    v_fact_ordenes_compra_sem_v2.monto_total,
    v_fact_ordenes_compra_sem_v2.cantidad_total,
    v_fact_ordenes_compra_sem_v2.cantidad_items,
    v_fact_ordenes_compra_sem_v2.estado_oc,
    v_fact_ordenes_compra_sem_v2.tipo_oc,
    v_fact_ordenes_compra_sem_v2.moneda,
    v_fact_ordenes_compra_sem_v2.periodo,
    v_fact_ordenes_compra_sem_v2.source_file,
    v_fact_ordenes_compra_sem_v2.ingested_at,
    v_fact_ordenes_compra_sem_v2.moneda_raw,
    v_fact_ordenes_compra_sem_v2.moneda_norm,
    v_fact_ordenes_compra_sem_v2.flag_moneda_missing,
    v_fact_ordenes_compra_sem_v2.flag_moneda_unknown,
    v_fact_ordenes_compra_sem_v2.sector_estado_norm,
    v_fact_ordenes_compra_sem_v2.flag_sector_missing,
    v_fact_ordenes_compra_sem_v2.flag_sector_unknown,
    v_fact_ordenes_compra_sem_v2.flag_organismo_valido,
    v_fact_ordenes_compra_sem_v2.flag_fuente_preferente_missing
   FROM dw_sem.v_fact_ordenes_compra_sem_v2;


--
-- Name: licitaciones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.licitaciones (
    id text NOT NULL,
    titulo text,
    estado text,
    fecha_publicacion timestamp without time zone,
    monto_estimado numeric,
    raw jsonb
);


--
-- Name: stg_lic_2024_09; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_lic_2024_09 (
    codigo text,
    link text,
    codigoexterno text,
    nombre text,
    descripcion text,
    tipo_de_adquisicion text,
    codigoestado text,
    estado text,
    codigoorganismo text,
    nombreorganismo text,
    sector text,
    rutunidad text,
    codigounidad text,
    nombreunidad text,
    direccionunidad text,
    comunaunidad text,
    regionunidad text,
    informada text,
    codigotipo text,
    tipo text,
    tipoconvocatoria text,
    codigomoneda text,
    moneda_adquisicion text,
    etapas text,
    estadoetapas text,
    tomarazon text,
    estadopublicidadofertas text,
    justificacionpublicidad text,
    estadocs text,
    contrato text,
    obras text,
    cantidadreclamos text,
    fechacreacion text,
    fechacierre text,
    fechainicio text,
    fechafinal text,
    fechapubrespuestas text,
    fechaactoaperturatecnica text,
    fechaactoaperturaeconomica text,
    fechapublicacion text,
    fechaadjudicacion text,
    fechaestimadaadjudicacion text,
    fechasoportefisico text,
    fechatiempoevaluacion text,
    unidadtiempoevaluacion text,
    fechaestimadafirma text,
    fechasusuario text,
    fechavisitaterreno text,
    direccionvisita text,
    fechaentregaantecedentes text,
    direccionentrega text,
    estimacion text,
    fuentefinanciamiento text,
    visibilidadmonto text,
    montoestimado text,
    tiempo text,
    unidadtiempo text,
    modalidad text,
    tipopago text,
    prohibicioncontratacion text,
    subcontratacion text,
    unidadtiempoduracioncontrato text,
    tiempoduracioncontrato text,
    tipoduracioncontrato text,
    justificacionmontoestimado text,
    observacioncontrato text,
    extensionplazo text,
    esbasetipo text,
    unidadtiempocontratolicitacion text,
    valortiemporenovacion text,
    periodotiemporenovacion text,
    esrenovable text,
    tipoaprobacion text,
    numeroaprobacion text,
    fechaaprobacion text,
    numerooferentes text,
    correlativo text,
    codigoestadolicitacion text,
    codigoitem text,
    codigoproductoonu text,
    rubro1 text,
    rubro2 text,
    rubro3 text,
    nombre_producto_genrico text,
    nombre_linea_adquisicion text,
    descripcion_linea_adquisicion text,
    unidadmedida text,
    cantidad text,
    codigoproveedor text,
    codigosucursalproveedor text,
    rutproveedor text,
    nombreproveedor text,
    razonsocialproveedor text,
    descripcionproveedor text,
    monto_estimado_adjudicado text,
    nombre_de_la_oferta text,
    estado_oferta text,
    cantidad_ofertada text,
    moneda_de_la_oferta text,
    montounitariooferta text,
    valor_total_ofertado text,
    cantidadadjudicada text,
    montolineaadjudica text,
    fechaenviooferta text,
    oferta_seleccionada text
);


--
-- Name: stg_lic_2024_10; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_lic_2024_10 (
    codigo text,
    link text,
    codigoexterno text,
    nombre text,
    descripcion text,
    tipo_de_adquisicion text,
    codigoestado text,
    estado text,
    codigoorganismo text,
    nombreorganismo text,
    sector text,
    rutunidad text,
    codigounidad text,
    nombreunidad text,
    direccionunidad text,
    comunaunidad text,
    regionunidad text,
    informada text,
    codigotipo text,
    tipo text,
    tipoconvocatoria text,
    codigomoneda text,
    moneda_adquisicion text,
    etapas text,
    estadoetapas text,
    tomarazon text,
    estadopublicidadofertas text,
    justificacionpublicidad text,
    estadocs text,
    contrato text,
    obras text,
    cantidadreclamos text,
    fechacreacion text,
    fechacierre text,
    fechainicio text,
    fechafinal text,
    fechapubrespuestas text,
    fechaactoaperturatecnica text,
    fechaactoaperturaeconomica text,
    fechapublicacion text,
    fechaadjudicacion text,
    fechaestimadaadjudicacion text,
    fechasoportefisico text,
    fechatiempoevaluacion text,
    unidadtiempoevaluacion text,
    fechaestimadafirma text,
    fechasusuario text,
    fechavisitaterreno text,
    direccionvisita text,
    fechaentregaantecedentes text,
    direccionentrega text,
    estimacion text,
    fuentefinanciamiento text,
    visibilidadmonto text,
    montoestimado text,
    tiempo text,
    unidadtiempo text,
    modalidad text,
    tipopago text,
    prohibicioncontratacion text,
    subcontratacion text,
    unidadtiempoduracioncontrato text,
    tiempoduracioncontrato text,
    tipoduracioncontrato text,
    justificacionmontoestimado text,
    observacioncontrato text,
    extensionplazo text,
    esbasetipo text,
    unidadtiempocontratolicitacion text,
    valortiemporenovacion text,
    periodotiemporenovacion text,
    esrenovable text,
    tipoaprobacion text,
    numeroaprobacion text,
    fechaaprobacion text,
    numerooferentes text,
    correlativo text,
    codigoestadolicitacion text,
    codigoitem text,
    codigoproductoonu text,
    rubro1 text,
    rubro2 text,
    rubro3 text,
    nombre_producto_genrico text,
    nombre_linea_adquisicion text,
    descripcion_linea_adquisicion text,
    unidadmedida text,
    cantidad text,
    codigoproveedor text,
    codigosucursalproveedor text,
    rutproveedor text,
    nombreproveedor text,
    razonsocialproveedor text,
    descripcionproveedor text,
    monto_estimado_adjudicado text,
    nombre_de_la_oferta text,
    estado_oferta text,
    cantidad_ofertada text,
    moneda_de_la_oferta text,
    montounitariooferta text,
    valor_total_ofertado text,
    cantidadadjudicada text,
    montolineaadjudica text,
    fechaenviooferta text,
    oferta_seleccionada text
);


--
-- Name: stg_lic_2024_11; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_lic_2024_11 (
    codigo text,
    link text,
    codigoexterno text,
    nombre text,
    descripcion text,
    tipo_de_adquisicion text,
    codigoestado text,
    estado text,
    codigoorganismo text,
    nombreorganismo text,
    sector text,
    rutunidad text,
    codigounidad text,
    nombreunidad text,
    direccionunidad text,
    comunaunidad text,
    regionunidad text,
    informada text,
    codigotipo text,
    tipo text,
    tipoconvocatoria text,
    codigomoneda text,
    moneda_adquisicion text,
    etapas text,
    estadoetapas text,
    tomarazon text,
    estadopublicidadofertas text,
    justificacionpublicidad text,
    estadocs text,
    contrato text,
    obras text,
    cantidadreclamos text,
    fechacreacion text,
    fechacierre text,
    fechainicio text,
    fechafinal text,
    fechapubrespuestas text,
    fechaactoaperturatecnica text,
    fechaactoaperturaeconomica text,
    fechapublicacion text,
    fechaadjudicacion text,
    fechaestimadaadjudicacion text,
    fechasoportefisico text,
    fechatiempoevaluacion text,
    unidadtiempoevaluacion text,
    fechaestimadafirma text,
    fechasusuario text,
    fechavisitaterreno text,
    direccionvisita text,
    fechaentregaantecedentes text,
    direccionentrega text,
    estimacion text,
    fuentefinanciamiento text,
    visibilidadmonto text,
    montoestimado text,
    tiempo text,
    unidadtiempo text,
    modalidad text,
    tipopago text,
    prohibicioncontratacion text,
    subcontratacion text,
    unidadtiempoduracioncontrato text,
    tiempoduracioncontrato text,
    tipoduracioncontrato text,
    justificacionmontoestimado text,
    observacioncontrato text,
    extensionplazo text,
    esbasetipo text,
    unidadtiempocontratolicitacion text,
    valortiemporenovacion text,
    periodotiemporenovacion text,
    esrenovable text,
    tipoaprobacion text,
    numeroaprobacion text,
    fechaaprobacion text,
    numerooferentes text,
    correlativo text,
    codigoestadolicitacion text,
    codigoitem text,
    codigoproductoonu text,
    rubro1 text,
    rubro2 text,
    rubro3 text,
    nombre_producto_genrico text,
    nombre_linea_adquisicion text,
    descripcion_linea_adquisicion text,
    unidadmedida text,
    cantidad text,
    codigoproveedor text,
    codigosucursalproveedor text,
    rutproveedor text,
    nombreproveedor text,
    razonsocialproveedor text,
    descripcionproveedor text,
    monto_estimado_adjudicado text,
    nombre_de_la_oferta text,
    estado_oferta text,
    cantidad_ofertada text,
    moneda_de_la_oferta text,
    montounitariooferta text,
    valor_total_ofertado text,
    cantidadadjudicada text,
    montolineaadjudica text,
    fechaenviooferta text,
    oferta_seleccionada text
);


--
-- Name: stg_lic_2024_12; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_lic_2024_12 (
    codigo text,
    link text,
    codigoexterno text,
    nombre text,
    descripcion text,
    tipo_de_adquisicion text,
    codigoestado text,
    estado text,
    codigoorganismo text,
    nombreorganismo text,
    sector text,
    rutunidad text,
    codigounidad text,
    nombreunidad text,
    direccionunidad text,
    comunaunidad text,
    regionunidad text,
    informada text,
    codigotipo text,
    tipo text,
    tipoconvocatoria text,
    codigomoneda text,
    moneda_adquisicion text,
    etapas text,
    estadoetapas text,
    tomarazon text,
    estadopublicidadofertas text,
    justificacionpublicidad text,
    estadocs text,
    contrato text,
    obras text,
    cantidadreclamos text,
    fechacreacion text,
    fechacierre text,
    fechainicio text,
    fechafinal text,
    fechapubrespuestas text,
    fechaactoaperturatecnica text,
    fechaactoaperturaeconomica text,
    fechapublicacion text,
    fechaadjudicacion text,
    fechaestimadaadjudicacion text,
    fechasoportefisico text,
    fechatiempoevaluacion text,
    unidadtiempoevaluacion text,
    fechaestimadafirma text,
    fechasusuario text,
    fechavisitaterreno text,
    direccionvisita text,
    fechaentregaantecedentes text,
    direccionentrega text,
    estimacion text,
    fuentefinanciamiento text,
    visibilidadmonto text,
    montoestimado text,
    tiempo text,
    unidadtiempo text,
    modalidad text,
    tipopago text,
    prohibicioncontratacion text,
    subcontratacion text,
    unidadtiempoduracioncontrato text,
    tiempoduracioncontrato text,
    tipoduracioncontrato text,
    justificacionmontoestimado text,
    observacioncontrato text,
    extensionplazo text,
    esbasetipo text,
    unidadtiempocontratolicitacion text,
    valortiemporenovacion text,
    periodotiemporenovacion text,
    esrenovable text,
    tipoaprobacion text,
    numeroaprobacion text,
    fechaaprobacion text,
    numerooferentes text,
    correlativo text,
    codigoestadolicitacion text,
    codigoitem text,
    codigoproductoonu text,
    rubro1 text,
    rubro2 text,
    rubro3 text,
    nombre_producto_genrico text,
    nombre_linea_adquisicion text,
    descripcion_linea_adquisicion text,
    unidadmedida text,
    cantidad text,
    codigoproveedor text,
    codigosucursalproveedor text,
    rutproveedor text,
    nombreproveedor text,
    razonsocialproveedor text,
    descripcionproveedor text,
    monto_estimado_adjudicado text,
    nombre_de_la_oferta text,
    estado_oferta text,
    cantidad_ofertada text,
    moneda_de_la_oferta text,
    montounitariooferta text,
    valor_total_ofertado text,
    cantidadadjudicada text,
    montolineaadjudica text,
    fechaenviooferta text,
    oferta_seleccionada text
);


--
-- Name: stg_lic_2025_01; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_lic_2025_01 (
    "id_licitacion,fechapublicacion,fechacierre,descripcion" text
);


--
-- Name: stg_lic_2025_02; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_lic_2025_02 (
    codigo text,
    link text,
    codigoexterno text,
    nombre text,
    descripcion text,
    tipo_de_adquisicion text,
    codigoestado text,
    estado text,
    codigoorganismo text,
    nombreorganismo text,
    sector text,
    rutunidad text,
    codigounidad text,
    nombreunidad text,
    direccionunidad text,
    comunaunidad text,
    regionunidad text,
    informada text,
    codigotipo text,
    tipo text,
    tipoconvocatoria text,
    codigomoneda text,
    moneda_adquisicion text,
    etapas text,
    estadoetapas text,
    tomarazon text,
    estadopublicidadofertas text,
    justificacionpublicidad text,
    estadocs text,
    contrato text,
    obras text,
    cantidadreclamos text,
    fechacreacion text,
    fechacierre text,
    fechainicio text,
    fechafinal text,
    fechapubrespuestas text,
    fechaactoaperturatecnica text,
    fechaactoaperturaeconomica text,
    fechapublicacion text,
    fechaadjudicacion text,
    fechaestimadaadjudicacion text,
    fechasoportefisico text,
    fechatiempoevaluacion text,
    unidadtiempoevaluacion text,
    fechaestimadafirma text,
    fechasusuario text,
    fechavisitaterreno text,
    direccionvisita text,
    fechaentregaantecedentes text,
    direccionentrega text,
    estimacion text,
    fuentefinanciamiento text,
    visibilidadmonto text,
    montoestimado text,
    tiempo text,
    unidadtiempo text,
    modalidad text,
    tipopago text,
    prohibicioncontratacion text,
    subcontratacion text,
    unidadtiempoduracioncontrato text,
    tiempoduracioncontrato text,
    tipoduracioncontrato text,
    justificacionmontoestimado text,
    observacioncontrato text,
    extensionplazo text,
    esbasetipo text,
    unidadtiempocontratolicitacion text,
    valortiemporenovacion text,
    periodotiemporenovacion text,
    esrenovable text,
    tipoaprobacion text,
    numeroaprobacion text,
    fechaaprobacion text,
    numerooferentes text,
    correlativo text,
    codigoestadolicitacion text,
    codigoitem text,
    codigoproductoonu text,
    rubro1 text,
    rubro2 text,
    rubro3 text,
    nombre_producto_genrico text,
    nombre_linea_adquisicion text,
    descripcion_linea_adquisicion text,
    unidadmedida text,
    cantidad text,
    codigoproveedor text,
    codigosucursalproveedor text,
    rutproveedor text,
    nombreproveedor text,
    razonsocialproveedor text,
    descripcionproveedor text,
    monto_estimado_adjudicado text,
    nombre_de_la_oferta text,
    estado_oferta text,
    cantidad_ofertada text,
    moneda_de_la_oferta text,
    montounitariooferta text,
    valor_total_ofertado text,
    cantidadadjudicada text,
    montolineaadjudica text,
    fechaenviooferta text,
    oferta_seleccionada text
);


--
-- Name: stg_lic_2025_03; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_lic_2025_03 (
    codigo text,
    link text,
    codigoexterno text,
    nombre text,
    descripcion text,
    tipo_de_adquisicion text,
    codigoestado text,
    estado text,
    codigoorganismo text,
    nombreorganismo text,
    sector text,
    rutunidad text,
    codigounidad text,
    nombreunidad text,
    direccionunidad text,
    comunaunidad text,
    regionunidad text,
    informada text,
    codigotipo text,
    tipo text,
    tipoconvocatoria text,
    codigomoneda text,
    moneda_adquisicion text,
    etapas text,
    estadoetapas text,
    tomarazon text,
    estadopublicidadofertas text,
    justificacionpublicidad text,
    estadocs text,
    contrato text,
    obras text,
    cantidadreclamos text,
    fechacreacion text,
    fechacierre text,
    fechainicio text,
    fechafinal text,
    fechapubrespuestas text,
    fechaactoaperturatecnica text,
    fechaactoaperturaeconomica text,
    fechapublicacion text,
    fechaadjudicacion text,
    fechaestimadaadjudicacion text,
    fechasoportefisico text,
    fechatiempoevaluacion text,
    unidadtiempoevaluacion text,
    fechaestimadafirma text,
    fechasusuario text,
    fechavisitaterreno text,
    direccionvisita text,
    fechaentregaantecedentes text,
    direccionentrega text,
    estimacion text,
    fuentefinanciamiento text,
    visibilidadmonto text,
    montoestimado text,
    tiempo text,
    unidadtiempo text,
    modalidad text,
    tipopago text,
    prohibicioncontratacion text,
    subcontratacion text,
    unidadtiempoduracioncontrato text,
    tiempoduracioncontrato text,
    tipoduracioncontrato text,
    justificacionmontoestimado text,
    observacioncontrato text,
    extensionplazo text,
    esbasetipo text,
    unidadtiempocontratolicitacion text,
    valortiemporenovacion text,
    periodotiemporenovacion text,
    esrenovable text,
    tipoaprobacion text,
    numeroaprobacion text,
    fechaaprobacion text,
    numerooferentes text,
    correlativo text,
    codigoestadolicitacion text,
    codigoitem text,
    codigoproductoonu text,
    rubro1 text,
    rubro2 text,
    rubro3 text,
    nombre_producto_genrico text,
    nombre_linea_adquisicion text,
    descripcion_linea_adquisicion text,
    unidadmedida text,
    cantidad text,
    codigoproveedor text,
    codigosucursalproveedor text,
    rutproveedor text,
    nombreproveedor text,
    razonsocialproveedor text,
    descripcionproveedor text,
    monto_estimado_adjudicado text,
    nombre_de_la_oferta text,
    estado_oferta text,
    cantidad_ofertada text,
    moneda_de_la_oferta text,
    montounitariooferta text,
    valor_total_ofertado text,
    cantidadadjudicada text,
    montolineaadjudica text,
    fechaenviooferta text,
    oferta_seleccionada text
);


--
-- Name: stg_lic_2025_04; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_lic_2025_04 (
    codigo text,
    link text,
    codigoexterno text,
    nombre text,
    descripcion text,
    tipo_de_adquisicion text,
    codigoestado text,
    estado text,
    codigoorganismo text,
    nombreorganismo text,
    sector text,
    rutunidad text,
    codigounidad text,
    nombreunidad text,
    direccionunidad text,
    comunaunidad text,
    regionunidad text,
    informada text,
    codigotipo text,
    tipo text,
    tipoconvocatoria text,
    codigomoneda text,
    moneda_adquisicion text,
    etapas text,
    estadoetapas text,
    tomarazon text,
    estadopublicidadofertas text,
    justificacionpublicidad text,
    estadocs text,
    contrato text,
    obras text,
    cantidadreclamos text,
    fechacreacion text,
    fechacierre text,
    fechainicio text,
    fechafinal text,
    fechapubrespuestas text,
    fechaactoaperturatecnica text,
    fechaactoaperturaeconomica text,
    fechapublicacion text,
    fechaadjudicacion text,
    fechaestimadaadjudicacion text,
    fechasoportefisico text,
    fechatiempoevaluacion text,
    unidadtiempoevaluacion text,
    fechaestimadafirma text,
    fechasusuario text,
    fechavisitaterreno text,
    direccionvisita text,
    fechaentregaantecedentes text,
    direccionentrega text,
    estimacion text,
    fuentefinanciamiento text,
    visibilidadmonto text,
    montoestimado text,
    tiempo text,
    unidadtiempo text,
    modalidad text,
    tipopago text,
    prohibicioncontratacion text,
    subcontratacion text,
    unidadtiempoduracioncontrato text,
    tiempoduracioncontrato text,
    tipoduracioncontrato text,
    justificacionmontoestimado text,
    observacioncontrato text,
    extensionplazo text,
    esbasetipo text,
    unidadtiempocontratolicitacion text,
    valortiemporenovacion text,
    periodotiemporenovacion text,
    esrenovable text,
    tipoaprobacion text,
    numeroaprobacion text,
    fechaaprobacion text,
    numerooferentes text,
    correlativo text,
    codigoestadolicitacion text,
    codigoitem text,
    codigoproductoonu text,
    rubro1 text,
    rubro2 text,
    rubro3 text,
    nombre_producto_genrico text,
    nombre_linea_adquisicion text,
    descripcion_linea_adquisicion text,
    unidadmedida text,
    cantidad text,
    codigoproveedor text,
    codigosucursalproveedor text,
    rutproveedor text,
    nombreproveedor text,
    razonsocialproveedor text,
    descripcionproveedor text,
    monto_estimado_adjudicado text,
    nombre_de_la_oferta text,
    estado_oferta text,
    cantidad_ofertada text,
    moneda_de_la_oferta text,
    montounitariooferta text,
    valor_total_ofertado text,
    cantidadadjudicada text,
    montolineaadjudica text,
    fechaenviooferta text,
    oferta_seleccionada text
);


--
-- Name: stg_lic_2025_05; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_lic_2025_05 (
    codigo text,
    link text,
    codigoexterno text,
    nombre text,
    descripcion text,
    tipo_de_adquisicion text,
    codigoestado text,
    estado text,
    codigoorganismo text,
    nombreorganismo text,
    sector text,
    rutunidad text,
    codigounidad text,
    nombreunidad text,
    direccionunidad text,
    comunaunidad text,
    regionunidad text,
    informada text,
    codigotipo text,
    tipo text,
    tipoconvocatoria text,
    codigomoneda text,
    moneda_adquisicion text,
    etapas text,
    estadoetapas text,
    tomarazon text,
    estadopublicidadofertas text,
    justificacionpublicidad text,
    estadocs text,
    contrato text,
    obras text,
    cantidadreclamos text,
    fechacreacion text,
    fechacierre text,
    fechainicio text,
    fechafinal text,
    fechapubrespuestas text,
    fechaactoaperturatecnica text,
    fechaactoaperturaeconomica text,
    fechapublicacion text,
    fechaadjudicacion text,
    fechaestimadaadjudicacion text,
    fechasoportefisico text,
    fechatiempoevaluacion text,
    unidadtiempoevaluacion text,
    fechaestimadafirma text,
    fechasusuario text,
    fechavisitaterreno text,
    direccionvisita text,
    fechaentregaantecedentes text,
    direccionentrega text,
    estimacion text,
    fuentefinanciamiento text,
    visibilidadmonto text,
    montoestimado text,
    tiempo text,
    unidadtiempo text,
    modalidad text,
    tipopago text,
    prohibicioncontratacion text,
    subcontratacion text,
    unidadtiempoduracioncontrato text,
    tiempoduracioncontrato text,
    tipoduracioncontrato text,
    justificacionmontoestimado text,
    observacioncontrato text,
    extensionplazo text,
    esbasetipo text,
    unidadtiempocontratolicitacion text,
    valortiemporenovacion text,
    periodotiemporenovacion text,
    esrenovable text,
    tipoaprobacion text,
    numeroaprobacion text,
    fechaaprobacion text,
    numerooferentes text,
    correlativo text,
    codigoestadolicitacion text,
    codigoitem text,
    codigoproductoonu text,
    rubro1 text,
    rubro2 text,
    rubro3 text,
    nombre_producto_genrico text,
    nombre_linea_adquisicion text,
    descripcion_linea_adquisicion text,
    unidadmedida text,
    cantidad text,
    codigoproveedor text,
    codigosucursalproveedor text,
    rutproveedor text,
    nombreproveedor text,
    razonsocialproveedor text,
    descripcionproveedor text,
    monto_estimado_adjudicado text,
    nombre_de_la_oferta text,
    estado_oferta text,
    cantidad_ofertada text,
    moneda_de_la_oferta text,
    montounitariooferta text,
    valor_total_ofertado text,
    cantidadadjudicada text,
    montolineaadjudica text,
    fechaenviooferta text,
    oferta_seleccionada text
);


--
-- Name: stg_lic_2025_06; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_lic_2025_06 (
    codigo text,
    link text,
    codigoexterno text,
    nombre text,
    descripcion text,
    tipo_de_adquisicion text,
    codigoestado text,
    estado text,
    codigoorganismo text,
    nombreorganismo text,
    sector text,
    rutunidad text,
    codigounidad text,
    nombreunidad text,
    direccionunidad text,
    comunaunidad text,
    regionunidad text,
    informada text,
    codigotipo text,
    tipo text,
    tipoconvocatoria text,
    codigomoneda text,
    moneda_adquisicion text,
    etapas text,
    estadoetapas text,
    tomarazon text,
    estadopublicidadofertas text,
    justificacionpublicidad text,
    estadocs text,
    contrato text,
    obras text,
    cantidadreclamos text,
    fechacreacion text,
    fechacierre text,
    fechainicio text,
    fechafinal text,
    fechapubrespuestas text,
    fechaactoaperturatecnica text,
    fechaactoaperturaeconomica text,
    fechapublicacion text,
    fechaadjudicacion text,
    fechaestimadaadjudicacion text,
    fechasoportefisico text,
    fechatiempoevaluacion text,
    unidadtiempoevaluacion text,
    fechaestimadafirma text,
    fechasusuario text,
    fechavisitaterreno text,
    direccionvisita text,
    fechaentregaantecedentes text,
    direccionentrega text,
    estimacion text,
    fuentefinanciamiento text,
    visibilidadmonto text,
    montoestimado text,
    tiempo text,
    unidadtiempo text,
    modalidad text,
    tipopago text,
    prohibicioncontratacion text,
    subcontratacion text,
    unidadtiempoduracioncontrato text,
    tiempoduracioncontrato text,
    tipoduracioncontrato text,
    justificacionmontoestimado text,
    observacioncontrato text,
    extensionplazo text,
    esbasetipo text,
    unidadtiempocontratolicitacion text,
    valortiemporenovacion text,
    periodotiemporenovacion text,
    esrenovable text,
    tipoaprobacion text,
    numeroaprobacion text,
    fechaaprobacion text,
    numerooferentes text,
    correlativo text,
    codigoestadolicitacion text,
    codigoitem text,
    codigoproductoonu text,
    rubro1 text,
    rubro2 text,
    rubro3 text,
    nombre_producto_genrico text,
    nombre_linea_adquisicion text,
    descripcion_linea_adquisicion text,
    unidadmedida text,
    cantidad text,
    codigoproveedor text,
    codigosucursalproveedor text,
    rutproveedor text,
    nombreproveedor text,
    razonsocialproveedor text,
    descripcionproveedor text,
    monto_estimado_adjudicado text,
    nombre_de_la_oferta text,
    estado_oferta text,
    cantidad_ofertada text,
    moneda_de_la_oferta text,
    montounitariooferta text,
    valor_total_ofertado text,
    cantidadadjudicada text,
    montolineaadjudica text,
    fechaenviooferta text,
    oferta_seleccionada text
);


--
-- Name: stg_lic_2025_07; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_lic_2025_07 (
    codigo text,
    link text,
    codigoexterno text,
    nombre text,
    descripcion text,
    tipo_de_adquisicion text,
    codigoestado text,
    estado text,
    codigoorganismo text,
    nombreorganismo text,
    sector text,
    rutunidad text,
    codigounidad text,
    nombreunidad text,
    direccionunidad text,
    comunaunidad text,
    regionunidad text,
    informada text,
    codigotipo text,
    tipo text,
    tipoconvocatoria text,
    codigomoneda text,
    moneda_adquisicion text,
    etapas text,
    estadoetapas text,
    tomarazon text,
    estadopublicidadofertas text,
    justificacionpublicidad text,
    estadocs text,
    contrato text,
    obras text,
    cantidadreclamos text,
    fechacreacion text,
    fechacierre text,
    fechainicio text,
    fechafinal text,
    fechapubrespuestas text,
    fechaactoaperturatecnica text,
    fechaactoaperturaeconomica text,
    fechapublicacion text,
    fechaadjudicacion text,
    fechaestimadaadjudicacion text,
    fechasoportefisico text,
    fechatiempoevaluacion text,
    unidadtiempoevaluacion text,
    fechaestimadafirma text,
    fechasusuario text,
    fechavisitaterreno text,
    direccionvisita text,
    fechaentregaantecedentes text,
    direccionentrega text,
    estimacion text,
    fuentefinanciamiento text,
    visibilidadmonto text,
    montoestimado text,
    tiempo text,
    unidadtiempo text,
    modalidad text,
    tipopago text,
    prohibicioncontratacion text,
    subcontratacion text,
    unidadtiempoduracioncontrato text,
    tiempoduracioncontrato text,
    tipoduracioncontrato text,
    justificacionmontoestimado text,
    observacioncontrato text,
    extensionplazo text,
    esbasetipo text,
    unidadtiempocontratolicitacion text,
    valortiemporenovacion text,
    periodotiemporenovacion text,
    esrenovable text,
    tipoaprobacion text,
    numeroaprobacion text,
    fechaaprobacion text,
    numerooferentes text,
    correlativo text,
    codigoestadolicitacion text,
    codigoitem text,
    codigoproductoonu text,
    rubro1 text,
    rubro2 text,
    rubro3 text,
    nombre_producto_genrico text,
    nombre_linea_adquisicion text,
    descripcion_linea_adquisicion text,
    unidadmedida text,
    cantidad text,
    codigoproveedor text,
    codigosucursalproveedor text,
    rutproveedor text,
    nombreproveedor text,
    razonsocialproveedor text,
    descripcionproveedor text,
    monto_estimado_adjudicado text,
    nombre_de_la_oferta text,
    estado_oferta text,
    cantidad_ofertada text,
    moneda_de_la_oferta text,
    montounitariooferta text,
    valor_total_ofertado text,
    cantidadadjudicada text,
    montolineaadjudica text,
    fechaenviooferta text,
    oferta_seleccionada text
);


--
-- Name: stg_lic_2025_08; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_lic_2025_08 (
    codigo text,
    link text,
    codigoexterno text,
    nombre text,
    descripcion text,
    tipo_de_adquisicion text,
    codigoestado text,
    estado text,
    codigoorganismo text,
    nombreorganismo text,
    sector text,
    rutunidad text,
    codigounidad text,
    nombreunidad text,
    direccionunidad text,
    comunaunidad text,
    regionunidad text,
    informada text,
    codigotipo text,
    tipo text,
    tipoconvocatoria text,
    codigomoneda text,
    moneda_adquisicion text,
    etapas text,
    estadoetapas text,
    tomarazon text,
    estadopublicidadofertas text,
    justificacionpublicidad text,
    estadocs text,
    contrato text,
    obras text,
    cantidadreclamos text,
    fechacreacion text,
    fechacierre text,
    fechainicio text,
    fechafinal text,
    fechapubrespuestas text,
    fechaactoaperturatecnica text,
    fechaactoaperturaeconomica text,
    fechapublicacion text,
    fechaadjudicacion text,
    fechaestimadaadjudicacion text,
    fechasoportefisico text,
    fechatiempoevaluacion text,
    unidadtiempoevaluacion text,
    fechaestimadafirma text,
    fechasusuario text,
    fechavisitaterreno text,
    direccionvisita text,
    fechaentregaantecedentes text,
    direccionentrega text,
    estimacion text,
    fuentefinanciamiento text,
    visibilidadmonto text,
    montoestimado text,
    tiempo text,
    unidadtiempo text,
    modalidad text,
    tipopago text,
    prohibicioncontratacion text,
    subcontratacion text,
    unidadtiempoduracioncontrato text,
    tiempoduracioncontrato text,
    tipoduracioncontrato text,
    justificacionmontoestimado text,
    observacioncontrato text,
    extensionplazo text,
    esbasetipo text,
    unidadtiempocontratolicitacion text,
    valortiemporenovacion text,
    periodotiemporenovacion text,
    esrenovable text,
    tipoaprobacion text,
    numeroaprobacion text,
    fechaaprobacion text,
    numerooferentes text,
    correlativo text,
    codigoestadolicitacion text,
    codigoitem text,
    codigoproductoonu text,
    rubro1 text,
    rubro2 text,
    rubro3 text,
    nombre_producto_genrico text,
    nombre_linea_adquisicion text,
    descripcion_linea_adquisicion text,
    unidadmedida text,
    cantidad text,
    codigoproveedor text,
    codigosucursalproveedor text,
    rutproveedor text,
    nombreproveedor text,
    razonsocialproveedor text,
    descripcionproveedor text,
    monto_estimado_adjudicado text,
    nombre_de_la_oferta text,
    estado_oferta text,
    cantidad_ofertada text,
    moneda_de_la_oferta text,
    montounitariooferta text,
    valor_total_ofertado text,
    cantidadadjudicada text,
    montolineaadjudica text,
    fechaenviooferta text,
    oferta_seleccionada text
);


--
-- Name: stg_lic_2025_09; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_lic_2025_09 (
    codigo text,
    link text,
    codigoexterno text,
    nombre text,
    descripcion text,
    tipo_de_adquisicion text,
    codigoestado text,
    estado text,
    codigoorganismo text,
    nombreorganismo text,
    sector text,
    rutunidad text,
    codigounidad text,
    nombreunidad text,
    direccionunidad text,
    comunaunidad text,
    regionunidad text,
    informada text,
    codigotipo text,
    tipo text,
    tipoconvocatoria text,
    codigomoneda text,
    moneda_adquisicion text,
    etapas text,
    estadoetapas text,
    tomarazon text,
    estadopublicidadofertas text,
    justificacionpublicidad text,
    estadocs text,
    contrato text,
    obras text,
    cantidadreclamos text,
    fechacreacion text,
    fechacierre text,
    fechainicio text,
    fechafinal text,
    fechapubrespuestas text,
    fechaactoaperturatecnica text,
    fechaactoaperturaeconomica text,
    fechapublicacion text,
    fechaadjudicacion text,
    fechaestimadaadjudicacion text,
    fechasoportefisico text,
    fechatiempoevaluacion text,
    unidadtiempoevaluacion text,
    fechaestimadafirma text,
    fechasusuario text,
    fechavisitaterreno text,
    direccionvisita text,
    fechaentregaantecedentes text,
    direccionentrega text,
    estimacion text,
    fuentefinanciamiento text,
    visibilidadmonto text,
    montoestimado text,
    tiempo text,
    unidadtiempo text,
    modalidad text,
    tipopago text,
    prohibicioncontratacion text,
    subcontratacion text,
    unidadtiempoduracioncontrato text,
    tiempoduracioncontrato text,
    tipoduracioncontrato text,
    justificacionmontoestimado text,
    observacioncontrato text,
    extensionplazo text,
    esbasetipo text,
    unidadtiempocontratolicitacion text,
    valortiemporenovacion text,
    periodotiemporenovacion text,
    esrenovable text,
    tipoaprobacion text,
    numeroaprobacion text,
    fechaaprobacion text,
    numerooferentes text,
    correlativo text,
    codigoestadolicitacion text,
    codigoitem text,
    codigoproductoonu text,
    rubro1 text,
    rubro2 text,
    rubro3 text,
    nombre_producto_genrico text,
    nombre_linea_adquisicion text,
    descripcion_linea_adquisicion text,
    unidadmedida text,
    cantidad text,
    codigoproveedor text,
    codigosucursalproveedor text,
    rutproveedor text,
    nombreproveedor text,
    razonsocialproveedor text,
    descripcionproveedor text,
    monto_estimado_adjudicado text,
    nombre_de_la_oferta text,
    estado_oferta text,
    cantidad_ofertada text,
    moneda_de_la_oferta text,
    montounitariooferta text,
    valor_total_ofertado text,
    cantidadadjudicada text,
    montolineaadjudica text,
    fechaenviooferta text,
    oferta_seleccionada text
);


--
-- Name: stg_lic_2025_10; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_lic_2025_10 (
    codigo text,
    link text,
    codigoexterno text,
    nombre text,
    descripcion text,
    tipo_de_adquisicion text,
    codigoestado text,
    estado text,
    codigoorganismo text,
    nombreorganismo text,
    sector text,
    rutunidad text,
    codigounidad text,
    nombreunidad text,
    direccionunidad text,
    comunaunidad text,
    regionunidad text,
    informada text,
    codigotipo text,
    tipo text,
    tipoconvocatoria text,
    codigomoneda text,
    moneda_adquisicion text,
    etapas text,
    estadoetapas text,
    tomarazon text,
    estadopublicidadofertas text,
    justificacionpublicidad text,
    estadocs text,
    contrato text,
    obras text,
    cantidadreclamos text,
    fechacreacion text,
    fechacierre text,
    fechainicio text,
    fechafinal text,
    fechapubrespuestas text,
    fechaactoaperturatecnica text,
    fechaactoaperturaeconomica text,
    fechapublicacion text,
    fechaadjudicacion text,
    fechaestimadaadjudicacion text,
    fechasoportefisico text,
    fechatiempoevaluacion text,
    unidadtiempoevaluacion text,
    fechaestimadafirma text,
    fechasusuario text,
    fechavisitaterreno text,
    direccionvisita text,
    fechaentregaantecedentes text,
    direccionentrega text,
    estimacion text,
    fuentefinanciamiento text,
    visibilidadmonto text,
    montoestimado text,
    tiempo text,
    unidadtiempo text,
    modalidad text,
    tipopago text,
    prohibicioncontratacion text,
    subcontratacion text,
    unidadtiempoduracioncontrato text,
    tiempoduracioncontrato text,
    tipoduracioncontrato text,
    justificacionmontoestimado text,
    observacioncontrato text,
    extensionplazo text,
    esbasetipo text,
    unidadtiempocontratolicitacion text,
    valortiemporenovacion text,
    periodotiemporenovacion text,
    esrenovable text,
    tipoaprobacion text,
    numeroaprobacion text,
    fechaaprobacion text,
    numerooferentes text,
    correlativo text,
    codigoestadolicitacion text,
    codigoitem text,
    codigoproductoonu text,
    rubro1 text,
    rubro2 text,
    rubro3 text,
    nombre_producto_genrico text,
    nombre_linea_adquisicion text,
    descripcion_linea_adquisicion text,
    unidadmedida text,
    cantidad text,
    codigoproveedor text,
    codigosucursalproveedor text,
    rutproveedor text,
    nombreproveedor text,
    razonsocialproveedor text,
    descripcionproveedor text,
    monto_estimado_adjudicado text,
    nombre_de_la_oferta text,
    estado_oferta text,
    cantidad_ofertada text,
    moneda_de_la_oferta text,
    montounitariooferta text,
    valor_total_ofertado text,
    cantidadadjudicada text,
    montolineaadjudica text,
    fechaenviooferta text,
    oferta_seleccionada text
);


--
-- Name: stg_oc_2024_09; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_oc_2024_09 (
    id text,
    codigo text,
    link text,
    nombre text,
    descripcion_obervaciones text,
    tipo text,
    procedenciaoc text,
    estratodirecto text,
    escompraagil text,
    codigotipo text,
    codigoabreviadotipooc text,
    descripciontipooc text,
    codigoestado text,
    estado text,
    codigoestadoproveedor text,
    estadoproveedor text,
    fechacreacion text,
    fechaenvio text,
    fechasolicitudcancelacion text,
    fechaultimamodificacion text,
    fechaaceptacion text,
    fechacancelacion text,
    tieneitems text,
    promediocalificacion text,
    cantidadevaluacion text,
    montototaloc text,
    tipomonedaoc text,
    montototaloc_pesoschilenos text,
    impuestos text,
    tipoimpuesto text,
    descuentos text,
    cargos text,
    totalnetooc text,
    codigounidadcompra text,
    rutunidadcompra text,
    unidadcompra text,
    codigoorganismopublico text,
    organismopublico text,
    sector text,
    actividadcomprador text,
    ciudadunidadcompra text,
    regionunidadcompra text,
    paisunidadcompra text,
    codigosucursal text,
    rutsucursal text,
    sucursal text,
    codigoproveedor text,
    nombreproveedor text,
    actividadproveedor text,
    comunaproveedor text,
    regionproveedor text,
    paisproveedor text,
    financiamiento text,
    porcentajeiva text,
    pais text,
    tipodespacho text,
    formapago text,
    codigolicitacion text,
    codigo_conveniomarco text,
    iditem text,
    codigocategoria text,
    categoria text,
    codigoproductoonu text,
    nombreroductogenerico text,
    rubron1 text,
    rubron2 text,
    rubron3 text,
    especificacioncomprador text,
    especificacionproveedor text,
    cantidad text,
    unidadmedida text,
    monedaitem text,
    precioneto text,
    totalcargos text,
    totaldescuentos text,
    totalimpuestos text,
    totallineaneto text,
    forma_de_pago text
);


--
-- Name: stg_oc_2024_10; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_oc_2024_10 (
    id text,
    codigo text,
    link text,
    nombre text,
    descripcion_obervaciones text,
    tipo text,
    procedenciaoc text,
    estratodirecto text,
    escompraagil text,
    codigotipo text,
    codigoabreviadotipooc text,
    descripciontipooc text,
    codigoestado text,
    estado text,
    codigoestadoproveedor text,
    estadoproveedor text,
    fechacreacion text,
    fechaenvio text,
    fechasolicitudcancelacion text,
    fechaultimamodificacion text,
    fechaaceptacion text,
    fechacancelacion text,
    tieneitems text,
    promediocalificacion text,
    cantidadevaluacion text,
    montototaloc text,
    tipomonedaoc text,
    montototaloc_pesoschilenos text,
    impuestos text,
    tipoimpuesto text,
    descuentos text,
    cargos text,
    totalnetooc text,
    codigounidadcompra text,
    rutunidadcompra text,
    unidadcompra text,
    codigoorganismopublico text,
    organismopublico text,
    sector text,
    actividadcomprador text,
    ciudadunidadcompra text,
    regionunidadcompra text,
    paisunidadcompra text,
    codigosucursal text,
    rutsucursal text,
    sucursal text,
    codigoproveedor text,
    nombreproveedor text,
    actividadproveedor text,
    comunaproveedor text,
    regionproveedor text,
    paisproveedor text,
    financiamiento text,
    porcentajeiva text,
    pais text,
    tipodespacho text,
    formapago text,
    codigolicitacion text,
    codigo_conveniomarco text,
    iditem text,
    codigocategoria text,
    categoria text,
    codigoproductoonu text,
    nombreroductogenerico text,
    rubron1 text,
    rubron2 text,
    rubron3 text,
    especificacioncomprador text,
    especificacionproveedor text,
    cantidad text,
    unidadmedida text,
    monedaitem text,
    precioneto text,
    totalcargos text,
    totaldescuentos text,
    totalimpuestos text,
    totallineaneto text,
    forma_de_pago text
);


--
-- Name: stg_oc_2024_11; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_oc_2024_11 (
    id text,
    codigo text,
    link text,
    nombre text,
    descripcion_obervaciones text,
    tipo text,
    procedenciaoc text,
    estratodirecto text,
    escompraagil text,
    codigotipo text,
    codigoabreviadotipooc text,
    descripciontipooc text,
    codigoestado text,
    estado text,
    codigoestadoproveedor text,
    estadoproveedor text,
    fechacreacion text,
    fechaenvio text,
    fechasolicitudcancelacion text,
    fechaultimamodificacion text,
    fechaaceptacion text,
    fechacancelacion text,
    tieneitems text,
    promediocalificacion text,
    cantidadevaluacion text,
    montototaloc text,
    tipomonedaoc text,
    montototaloc_pesoschilenos text,
    impuestos text,
    tipoimpuesto text,
    descuentos text,
    cargos text,
    totalnetooc text,
    codigounidadcompra text,
    rutunidadcompra text,
    unidadcompra text,
    codigoorganismopublico text,
    organismopublico text,
    sector text,
    actividadcomprador text,
    ciudadunidadcompra text,
    regionunidadcompra text,
    paisunidadcompra text,
    codigosucursal text,
    rutsucursal text,
    sucursal text,
    codigoproveedor text,
    nombreproveedor text,
    actividadproveedor text,
    comunaproveedor text,
    regionproveedor text,
    paisproveedor text,
    financiamiento text,
    porcentajeiva text,
    pais text,
    tipodespacho text,
    formapago text,
    codigolicitacion text,
    codigo_conveniomarco text,
    iditem text,
    codigocategoria text,
    categoria text,
    codigoproductoonu text,
    nombreroductogenerico text,
    rubron1 text,
    rubron2 text,
    rubron3 text,
    especificacioncomprador text,
    especificacionproveedor text,
    cantidad text,
    unidadmedida text,
    monedaitem text,
    precioneto text,
    totalcargos text,
    totaldescuentos text,
    totalimpuestos text,
    totallineaneto text,
    forma_de_pago text
);


--
-- Name: stg_oc_2024_12; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_oc_2024_12 (
    id text,
    codigo text,
    link text,
    nombre text,
    descripcion_obervaciones text,
    tipo text,
    procedenciaoc text,
    estratodirecto text,
    escompraagil text,
    codigotipo text,
    codigoabreviadotipooc text,
    descripciontipooc text,
    codigoestado text,
    estado text,
    codigoestadoproveedor text,
    estadoproveedor text,
    fechacreacion text,
    fechaenvio text,
    fechasolicitudcancelacion text,
    fechaultimamodificacion text,
    fechaaceptacion text,
    fechacancelacion text,
    tieneitems text,
    promediocalificacion text,
    cantidadevaluacion text,
    montototaloc text,
    tipomonedaoc text,
    montototaloc_pesoschilenos text,
    impuestos text,
    tipoimpuesto text,
    descuentos text,
    cargos text,
    totalnetooc text,
    codigounidadcompra text,
    rutunidadcompra text,
    unidadcompra text,
    codigoorganismopublico text,
    organismopublico text,
    sector text,
    actividadcomprador text,
    ciudadunidadcompra text,
    regionunidadcompra text,
    paisunidadcompra text,
    codigosucursal text,
    rutsucursal text,
    sucursal text,
    codigoproveedor text,
    nombreproveedor text,
    actividadproveedor text,
    comunaproveedor text,
    regionproveedor text,
    paisproveedor text,
    financiamiento text,
    porcentajeiva text,
    pais text,
    tipodespacho text,
    formapago text,
    codigolicitacion text,
    codigo_conveniomarco text,
    iditem text,
    codigocategoria text,
    categoria text,
    codigoproductoonu text,
    nombreroductogenerico text,
    rubron1 text,
    rubron2 text,
    rubron3 text,
    especificacioncomprador text,
    especificacionproveedor text,
    cantidad text,
    unidadmedida text,
    monedaitem text,
    precioneto text,
    totalcargos text,
    totaldescuentos text,
    totalimpuestos text,
    totallineaneto text,
    forma_de_pago text
);


--
-- Name: stg_oc_2025_01; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_oc_2025_01 (
    id text,
    codigo text,
    link text,
    nombre text,
    descripcion_obervaciones text,
    tipo text,
    procedenciaoc text,
    estratodirecto text,
    escompraagil text,
    codigotipo text,
    codigoabreviadotipooc text,
    descripciontipooc text,
    codigoestado text,
    estado text,
    codigoestadoproveedor text,
    estadoproveedor text,
    fechacreacion text,
    fechaenvio text,
    fechasolicitudcancelacion text,
    fechaultimamodificacion text,
    fechaaceptacion text,
    fechacancelacion text,
    tieneitems text,
    promediocalificacion text,
    cantidadevaluacion text,
    montototaloc text,
    tipomonedaoc text,
    montototaloc_pesoschilenos text,
    impuestos text,
    tipoimpuesto text,
    descuentos text,
    cargos text,
    totalnetooc text,
    codigounidadcompra text,
    rutunidadcompra text,
    unidadcompra text,
    codigoorganismopublico text,
    organismopublico text,
    sector text,
    actividadcomprador text,
    ciudadunidadcompra text,
    regionunidadcompra text,
    paisunidadcompra text,
    codigosucursal text,
    rutsucursal text,
    sucursal text,
    codigoproveedor text,
    nombreproveedor text,
    actividadproveedor text,
    comunaproveedor text,
    regionproveedor text,
    paisproveedor text,
    financiamiento text,
    porcentajeiva text,
    pais text,
    tipodespacho text,
    formapago text,
    codigolicitacion text,
    codigo_conveniomarco text,
    iditem text,
    codigocategoria text,
    categoria text,
    codigoproductoonu text,
    nombreroductogenerico text,
    rubron1 text,
    rubron2 text,
    rubron3 text,
    especificacioncomprador text,
    especificacionproveedor text,
    cantidad text,
    unidadmedida text,
    monedaitem text,
    precioneto text,
    totalcargos text,
    totaldescuentos text,
    totalimpuestos text,
    totallineaneto text,
    forma_de_pago text
);


--
-- Name: stg_oc_2025_02; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_oc_2025_02 (
    id text,
    codigo text,
    link text,
    nombre text,
    descripcion_obervaciones text,
    tipo text,
    procedenciaoc text,
    estratodirecto text,
    escompraagil text,
    codigotipo text,
    codigoabreviadotipooc text,
    descripciontipooc text,
    codigoestado text,
    estado text,
    codigoestadoproveedor text,
    estadoproveedor text,
    fechacreacion text,
    fechaenvio text,
    fechasolicitudcancelacion text,
    fechaultimamodificacion text,
    fechaaceptacion text,
    fechacancelacion text,
    tieneitems text,
    promediocalificacion text,
    cantidadevaluacion text,
    montototaloc text,
    tipomonedaoc text,
    montototaloc_pesoschilenos text,
    impuestos text,
    tipoimpuesto text,
    descuentos text,
    cargos text,
    totalnetooc text,
    codigounidadcompra text,
    rutunidadcompra text,
    unidadcompra text,
    codigoorganismopublico text,
    organismopublico text,
    sector text,
    actividadcomprador text,
    ciudadunidadcompra text,
    regionunidadcompra text,
    paisunidadcompra text,
    codigosucursal text,
    rutsucursal text,
    sucursal text,
    codigoproveedor text,
    nombreproveedor text,
    actividadproveedor text,
    comunaproveedor text,
    regionproveedor text,
    paisproveedor text,
    financiamiento text,
    porcentajeiva text,
    pais text,
    tipodespacho text,
    formapago text,
    codigolicitacion text,
    codigo_conveniomarco text,
    iditem text,
    codigocategoria text,
    categoria text,
    codigoproductoonu text,
    nombreroductogenerico text,
    rubron1 text,
    rubron2 text,
    rubron3 text,
    especificacioncomprador text,
    especificacionproveedor text,
    cantidad text,
    unidadmedida text,
    monedaitem text,
    precioneto text,
    totalcargos text,
    totaldescuentos text,
    totalimpuestos text,
    totallineaneto text,
    forma_de_pago text
);


--
-- Name: stg_oc_2025_03; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_oc_2025_03 (
    x text
);


--
-- Name: stg_oc_2025_04; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_oc_2025_04 (
    id text,
    codigo text,
    link text,
    nombre text,
    descripcion_obervaciones text,
    tipo text,
    procedenciaoc text,
    estratodirecto text,
    escompraagil text,
    codigotipo text,
    codigoabreviadotipooc text,
    descripciontipooc text,
    codigoestado text,
    estado text,
    codigoestadoproveedor text,
    estadoproveedor text,
    fechacreacion text,
    fechaenvio text,
    fechasolicitudcancelacion text,
    fechaultimamodificacion text,
    fechaaceptacion text,
    fechacancelacion text,
    tieneitems text,
    promediocalificacion text,
    cantidadevaluacion text,
    montototaloc text,
    tipomonedaoc text,
    montototaloc_pesoschilenos text,
    impuestos text,
    tipoimpuesto text,
    descuentos text,
    cargos text,
    totalnetooc text,
    codigounidadcompra text,
    rutunidadcompra text,
    unidadcompra text,
    codigoorganismopublico text,
    organismopublico text,
    sector text,
    actividadcomprador text,
    ciudadunidadcompra text,
    regionunidadcompra text,
    paisunidadcompra text,
    codigosucursal text,
    rutsucursal text,
    sucursal text,
    codigoproveedor text,
    nombreproveedor text,
    actividadproveedor text,
    comunaproveedor text,
    regionproveedor text,
    paisproveedor text,
    financiamiento text,
    porcentajeiva text,
    pais text,
    tipodespacho text,
    formapago text,
    codigolicitacion text,
    codigo_conveniomarco text,
    iditem text,
    codigocategoria text,
    categoria text,
    codigoproductoonu text,
    nombreroductogenerico text,
    rubron1 text,
    rubron2 text,
    rubron3 text,
    especificacioncomprador text,
    especificacionproveedor text,
    cantidad text,
    unidadmedida text,
    monedaitem text,
    precioneto text,
    totalcargos text,
    totaldescuentos text,
    totalimpuestos text,
    totallineaneto text,
    forma_de_pago text
);


--
-- Name: stg_oc_2025_05; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_oc_2025_05 (
    id text,
    codigo text,
    link text,
    nombre text,
    descripcion_obervaciones text,
    tipo text,
    procedenciaoc text,
    estratodirecto text,
    escompraagil text,
    codigotipo text,
    codigoabreviadotipooc text,
    descripciontipooc text,
    codigoestado text,
    estado text,
    codigoestadoproveedor text,
    estadoproveedor text,
    fechacreacion text,
    fechaenvio text,
    fechasolicitudcancelacion text,
    fechaultimamodificacion text,
    fechaaceptacion text,
    fechacancelacion text,
    tieneitems text,
    promediocalificacion text,
    cantidadevaluacion text,
    montototaloc text,
    tipomonedaoc text,
    montototaloc_pesoschilenos text,
    impuestos text,
    tipoimpuesto text,
    descuentos text,
    cargos text,
    totalnetooc text,
    codigounidadcompra text,
    rutunidadcompra text,
    unidadcompra text,
    codigoorganismopublico text,
    organismopublico text,
    sector text,
    actividadcomprador text,
    ciudadunidadcompra text,
    regionunidadcompra text,
    paisunidadcompra text,
    codigosucursal text,
    rutsucursal text,
    sucursal text,
    codigoproveedor text,
    nombreproveedor text,
    actividadproveedor text,
    comunaproveedor text,
    regionproveedor text,
    paisproveedor text,
    financiamiento text,
    porcentajeiva text,
    pais text,
    tipodespacho text,
    formapago text,
    codigolicitacion text,
    codigo_conveniomarco text,
    iditem text,
    codigocategoria text,
    categoria text,
    codigoproductoonu text,
    nombreroductogenerico text,
    rubron1 text,
    rubron2 text,
    rubron3 text,
    especificacioncomprador text,
    especificacionproveedor text,
    cantidad text,
    unidadmedida text,
    monedaitem text,
    precioneto text,
    totalcargos text,
    totaldescuentos text,
    totalimpuestos text,
    totallineaneto text,
    forma_de_pago text
);


--
-- Name: stg_oc_2025_06; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_oc_2025_06 (
    id text,
    codigo text,
    link text,
    nombre text,
    descripcion_obervaciones text,
    tipo text,
    procedenciaoc text,
    estratodirecto text,
    escompraagil text,
    codigotipo text,
    codigoabreviadotipooc text,
    descripciontipooc text,
    codigoestado text,
    estado text,
    codigoestadoproveedor text,
    estadoproveedor text,
    fechacreacion text,
    fechaenvio text,
    fechasolicitudcancelacion text,
    fechaultimamodificacion text,
    fechaaceptacion text,
    fechacancelacion text,
    tieneitems text,
    promediocalificacion text,
    cantidadevaluacion text,
    montototaloc text,
    tipomonedaoc text,
    montototaloc_pesoschilenos text,
    impuestos text,
    tipoimpuesto text,
    descuentos text,
    cargos text,
    totalnetooc text,
    codigounidadcompra text,
    rutunidadcompra text,
    unidadcompra text,
    codigoorganismopublico text,
    organismopublico text,
    sector text,
    actividadcomprador text,
    ciudadunidadcompra text,
    regionunidadcompra text,
    paisunidadcompra text,
    codigosucursal text,
    rutsucursal text,
    sucursal text,
    codigoproveedor text,
    nombreproveedor text,
    actividadproveedor text,
    comunaproveedor text,
    regionproveedor text,
    paisproveedor text,
    financiamiento text,
    porcentajeiva text,
    pais text,
    tipodespacho text,
    formapago text,
    codigolicitacion text,
    codigo_conveniomarco text,
    iditem text,
    codigocategoria text,
    categoria text,
    codigoproductoonu text,
    nombreroductogenerico text,
    rubron1 text,
    rubron2 text,
    rubron3 text,
    especificacioncomprador text,
    especificacionproveedor text,
    cantidad text,
    unidadmedida text,
    monedaitem text,
    precioneto text,
    totalcargos text,
    totaldescuentos text,
    totalimpuestos text,
    totallineaneto text,
    forma_de_pago text
);


--
-- Name: stg_oc_2025_07; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_oc_2025_07 (
    id text,
    codigo text,
    link text,
    nombre text,
    descripcion_obervaciones text,
    tipo text,
    procedenciaoc text,
    estratodirecto text,
    escompraagil text,
    codigotipo text,
    codigoabreviadotipooc text,
    descripciontipooc text,
    codigoestado text,
    estado text,
    codigoestadoproveedor text,
    estadoproveedor text,
    fechacreacion text,
    fechaenvio text,
    fechasolicitudcancelacion text,
    fechaultimamodificacion text,
    fechaaceptacion text,
    fechacancelacion text,
    tieneitems text,
    promediocalificacion text,
    cantidadevaluacion text,
    montototaloc text,
    tipomonedaoc text,
    montototaloc_pesoschilenos text,
    impuestos text,
    tipoimpuesto text,
    descuentos text,
    cargos text,
    totalnetooc text,
    codigounidadcompra text,
    rutunidadcompra text,
    unidadcompra text,
    codigoorganismopublico text,
    organismopublico text,
    sector text,
    actividadcomprador text,
    ciudadunidadcompra text,
    regionunidadcompra text,
    paisunidadcompra text,
    codigosucursal text,
    rutsucursal text,
    sucursal text,
    codigoproveedor text,
    nombreproveedor text,
    actividadproveedor text,
    comunaproveedor text,
    regionproveedor text,
    paisproveedor text,
    financiamiento text,
    porcentajeiva text,
    pais text,
    tipodespacho text,
    formapago text,
    codigolicitacion text,
    codigo_conveniomarco text,
    iditem text,
    codigocategoria text,
    categoria text,
    codigoproductoonu text,
    nombreroductogenerico text,
    rubron1 text,
    rubron2 text,
    rubron3 text,
    especificacioncomprador text,
    especificacionproveedor text,
    cantidad text,
    unidadmedida text,
    monedaitem text,
    precioneto text,
    totalcargos text,
    totaldescuentos text,
    totalimpuestos text,
    totallineaneto text,
    forma_de_pago text
);


--
-- Name: stg_oc_2025_08; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_oc_2025_08 (
    id text,
    codigo text,
    link text,
    nombre text,
    descripcion_obervaciones text,
    tipo text,
    procedenciaoc text,
    estratodirecto text,
    escompraagil text,
    codigotipo text,
    codigoabreviadotipooc text,
    descripciontipooc text,
    codigoestado text,
    estado text,
    codigoestadoproveedor text,
    estadoproveedor text,
    fechacreacion text,
    fechaenvio text,
    fechasolicitudcancelacion text,
    fechaultimamodificacion text,
    fechaaceptacion text,
    fechacancelacion text,
    tieneitems text,
    promediocalificacion text,
    cantidadevaluacion text,
    montototaloc text,
    tipomonedaoc text,
    montototaloc_pesoschilenos text,
    impuestos text,
    tipoimpuesto text,
    descuentos text,
    cargos text,
    totalnetooc text,
    codigounidadcompra text,
    rutunidadcompra text,
    unidadcompra text,
    codigoorganismopublico text,
    organismopublico text,
    sector text,
    actividadcomprador text,
    ciudadunidadcompra text,
    regionunidadcompra text,
    paisunidadcompra text,
    codigosucursal text,
    rutsucursal text,
    sucursal text,
    codigoproveedor text,
    nombreproveedor text,
    actividadproveedor text,
    comunaproveedor text,
    regionproveedor text,
    paisproveedor text,
    financiamiento text,
    porcentajeiva text,
    pais text,
    tipodespacho text,
    formapago text,
    codigolicitacion text,
    codigo_conveniomarco text,
    iditem text,
    codigocategoria text,
    categoria text,
    codigoproductoonu text,
    nombreroductogenerico text,
    rubron1 text,
    rubron2 text,
    rubron3 text,
    especificacioncomprador text,
    especificacionproveedor text,
    cantidad text,
    unidadmedida text,
    monedaitem text,
    precioneto text,
    totalcargos text,
    totaldescuentos text,
    totalimpuestos text,
    totallineaneto text,
    forma_de_pago text
);


--
-- Name: stg_oc_2025_09; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_oc_2025_09 (
    id text,
    codigo text,
    link text,
    nombre text,
    descripcion_obervaciones text,
    tipo text,
    procedenciaoc text,
    estratodirecto text,
    escompraagil text,
    codigotipo text,
    codigoabreviadotipooc text,
    descripciontipooc text,
    codigoestado text,
    estado text,
    codigoestadoproveedor text,
    estadoproveedor text,
    fechacreacion text,
    fechaenvio text,
    fechasolicitudcancelacion text,
    fechaultimamodificacion text,
    fechaaceptacion text,
    fechacancelacion text,
    tieneitems text,
    promediocalificacion text,
    cantidadevaluacion text,
    montototaloc text,
    tipomonedaoc text,
    montototaloc_pesoschilenos text,
    impuestos text,
    tipoimpuesto text,
    descuentos text,
    cargos text,
    totalnetooc text,
    codigounidadcompra text,
    rutunidadcompra text,
    unidadcompra text,
    codigoorganismopublico text,
    organismopublico text,
    sector text,
    actividadcomprador text,
    ciudadunidadcompra text,
    regionunidadcompra text,
    paisunidadcompra text,
    codigosucursal text,
    rutsucursal text,
    sucursal text,
    codigoproveedor text,
    nombreproveedor text,
    actividadproveedor text,
    comunaproveedor text,
    regionproveedor text,
    paisproveedor text,
    financiamiento text,
    porcentajeiva text,
    pais text,
    tipodespacho text,
    formapago text,
    codigolicitacion text,
    codigo_conveniomarco text,
    iditem text,
    codigocategoria text,
    categoria text,
    codigoproductoonu text,
    nombreroductogenerico text,
    rubron1 text,
    rubron2 text,
    rubron3 text,
    especificacioncomprador text,
    especificacionproveedor text,
    cantidad text,
    unidadmedida text,
    monedaitem text,
    precioneto text,
    totalcargos text,
    totaldescuentos text,
    totalimpuestos text,
    totallineaneto text,
    forma_de_pago text
);


--
-- Name: stg_oc_2025_10; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stg_oc_2025_10 (
    id text,
    codigo text,
    link text,
    nombre text,
    descripcion_obervaciones text,
    tipo text,
    procedenciaoc text,
    estratodirecto text,
    escompraagil text,
    codigotipo text,
    codigoabreviadotipooc text,
    descripciontipooc text,
    codigoestado text,
    estado text,
    codigoestadoproveedor text,
    estadoproveedor text,
    fechacreacion text,
    fechaenvio text,
    fechasolicitudcancelacion text,
    fechaultimamodificacion text,
    fechaaceptacion text,
    fechacancelacion text,
    tieneitems text,
    promediocalificacion text,
    cantidadevaluacion text,
    montototaloc text,
    tipomonedaoc text,
    montototaloc_pesoschilenos text,
    impuestos text,
    tipoimpuesto text,
    descuentos text,
    cargos text,
    totalnetooc text,
    codigounidadcompra text,
    rutunidadcompra text,
    unidadcompra text,
    codigoorganismopublico text,
    organismopublico text,
    sector text,
    actividadcomprador text,
    ciudadunidadcompra text,
    regionunidadcompra text,
    paisunidadcompra text,
    codigosucursal text,
    rutsucursal text,
    sucursal text,
    codigoproveedor text,
    nombreproveedor text,
    actividadproveedor text,
    comunaproveedor text,
    regionproveedor text,
    paisproveedor text,
    financiamiento text,
    porcentajeiva text,
    pais text,
    tipodespacho text,
    formapago text,
    codigolicitacion text,
    codigo_conveniomarco text,
    iditem text,
    codigocategoria text,
    categoria text,
    codigoproductoonu text,
    nombreroductogenerico text,
    rubron1 text,
    rubron2 text,
    rubron3 text,
    especificacioncomprador text,
    especificacionproveedor text,
    cantidad text,
    unidadmedida text,
    monedaitem text,
    precioneto text,
    totalcargos text,
    totaldescuentos text,
    totalimpuestos text,
    totallineaneto text,
    forma_de_pago text
);


--
-- Name: vw_audit_staging_lic_oc; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.vw_audit_staging_lic_oc AS
 SELECT columns.table_name,
    columns.column_name,
    columns.data_type,
    columns.is_nullable,
    columns.ordinal_position
   FROM information_schema.columns
  WHERE ((columns.table_name)::name = ANY (ARRAY['stg_lic_2024_09'::name, 'stg_oc_2024_09'::name]))
  ORDER BY columns.table_name, columns.ordinal_position;


--
-- Name: dim_fecha dim_fecha_pkey; Type: CONSTRAINT; Schema: dw; Owner: -
--

ALTER TABLE ONLY dw.dim_fecha
    ADD CONSTRAINT dim_fecha_pkey PRIMARY KEY (fecha_sk);


--
-- Name: dim_organismo dim_organismo_pkey; Type: CONSTRAINT; Schema: dw; Owner: -
--

ALTER TABLE ONLY dw.dim_organismo
    ADD CONSTRAINT dim_organismo_pkey PRIMARY KEY (organismo_sk);


--
-- Name: dim_producto_onu dim_producto_onu_pkey; Type: CONSTRAINT; Schema: dw; Owner: -
--

ALTER TABLE ONLY dw.dim_producto_onu
    ADD CONSTRAINT dim_producto_onu_pkey PRIMARY KEY (producto_onu_sk);


--
-- Name: dim_proveedor dim_proveedor_pkey; Type: CONSTRAINT; Schema: dw; Owner: -
--

ALTER TABLE ONLY dw.dim_proveedor
    ADD CONSTRAINT dim_proveedor_pkey PRIMARY KEY (proveedor_sk);


--
-- Name: etl_control_cargas etl_control_cargas_pkey; Type: CONSTRAINT; Schema: dw; Owner: -
--

ALTER TABLE ONLY dw.etl_control_cargas
    ADD CONSTRAINT etl_control_cargas_pkey PRIMARY KEY (entidad, periodo);


--
-- Name: etl_decisiones_periodo etl_decisiones_periodo_pkey; Type: CONSTRAINT; Schema: dw; Owner: -
--

ALTER TABLE ONLY dw.etl_decisiones_periodo
    ADD CONSTRAINT etl_decisiones_periodo_pkey PRIMARY KEY (periodo);


--
-- Name: fact_licitaciones fact_licitaciones_pkey; Type: CONSTRAINT; Schema: dw; Owner: -
--

ALTER TABLE ONLY dw.fact_licitaciones
    ADD CONSTRAINT fact_licitaciones_pkey PRIMARY KEY (licitacion_sk);


--
-- Name: fact_ordenes_compra fact_ordenes_compra_pkey; Type: CONSTRAINT; Schema: dw; Owner: -
--

ALTER TABLE ONLY dw.fact_ordenes_compra
    ADD CONSTRAINT fact_ordenes_compra_pkey PRIMARY KEY (orden_compra_sk);


--
-- Name: licitaciones licitaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.licitaciones
    ADD CONSTRAINT licitaciones_pkey PRIMARY KEY (id);


--
-- Name: ix_fact_lic_fpub; Type: INDEX; Schema: dw; Owner: -
--

CREATE INDEX ix_fact_lic_fpub ON dw.fact_licitaciones USING btree (fecha_publicacion_sk);


--
-- Name: ix_fact_lic_org; Type: INDEX; Schema: dw; Owner: -
--

CREATE INDEX ix_fact_lic_org ON dw.fact_licitaciones USING btree (organismo_sk);


--
-- Name: ix_fact_lic_periodo; Type: INDEX; Schema: dw; Owner: -
--

CREATE INDEX ix_fact_lic_periodo ON dw.fact_licitaciones USING btree (periodo);


--
-- Name: ix_fact_lic_prod; Type: INDEX; Schema: dw; Owner: -
--

CREATE INDEX ix_fact_lic_prod ON dw.fact_licitaciones USING btree (producto_onu_sk);


--
-- Name: ix_fact_lic_prov; Type: INDEX; Schema: dw; Owner: -
--

CREATE INDEX ix_fact_lic_prov ON dw.fact_licitaciones USING btree (proveedor_sk);


--
-- Name: ix_fact_oc_fcrea; Type: INDEX; Schema: dw; Owner: -
--

CREATE INDEX ix_fact_oc_fcrea ON dw.fact_ordenes_compra USING btree (fecha_creacion_sk);


--
-- Name: ix_fact_oc_org; Type: INDEX; Schema: dw; Owner: -
--

CREATE INDEX ix_fact_oc_org ON dw.fact_ordenes_compra USING btree (organismo_sk);


--
-- Name: ix_fact_oc_periodo; Type: INDEX; Schema: dw; Owner: -
--

CREATE INDEX ix_fact_oc_periodo ON dw.fact_ordenes_compra USING btree (periodo);


--
-- Name: ix_fact_oc_prod; Type: INDEX; Schema: dw; Owner: -
--

CREATE INDEX ix_fact_oc_prod ON dw.fact_ordenes_compra USING btree (producto_onu_sk);


--
-- Name: ix_fact_oc_prov; Type: INDEX; Schema: dw; Owner: -
--

CREATE INDEX ix_fact_oc_prov ON dw.fact_ordenes_compra USING btree (proveedor_sk);


--
-- Name: ux_dim_fecha_fecha; Type: INDEX; Schema: dw; Owner: -
--

CREATE UNIQUE INDEX ux_dim_fecha_fecha ON dw.dim_fecha USING btree (fecha);


--
-- Name: ux_dim_organismo_codigo; Type: INDEX; Schema: dw; Owner: -
--

CREATE UNIQUE INDEX ux_dim_organismo_codigo ON dw.dim_organismo USING btree (codigo_organismo);


--
-- Name: ux_dim_producto_onu_codigo; Type: INDEX; Schema: dw; Owner: -
--

CREATE UNIQUE INDEX ux_dim_producto_onu_codigo ON dw.dim_producto_onu USING btree (codigo_producto_onu);


--
-- Name: ux_dim_proveedor_codigo; Type: INDEX; Schema: dw; Owner: -
--

CREATE UNIQUE INDEX ux_dim_proveedor_codigo ON dw.dim_proveedor USING btree (codigo_proveedor);


--
-- Name: ux_fact_lic_bk_periodo; Type: INDEX; Schema: dw; Owner: -
--

CREATE UNIQUE INDEX ux_fact_lic_bk_periodo ON dw.fact_licitaciones USING btree (licitacion_bk, periodo);


--
-- Name: ux_fact_oc_bk_periodo; Type: INDEX; Schema: dw; Owner: -
--

CREATE UNIQUE INDEX ux_fact_oc_bk_periodo ON dw.fact_ordenes_compra USING btree (orden_compra_bk, periodo);


--
-- Name: idx_licitaciones_estado; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_licitaciones_estado ON public.licitaciones USING btree (estado);


--
-- Name: idx_licitaciones_fecha; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_licitaciones_fecha ON public.licitaciones USING btree (fecha_publicacion);


--
-- Name: fact_licitaciones fk_fact_lic_fecha_cierre; Type: FK CONSTRAINT; Schema: dw; Owner: -
--

ALTER TABLE ONLY dw.fact_licitaciones
    ADD CONSTRAINT fk_fact_lic_fecha_cierre FOREIGN KEY (fecha_cierre_sk) REFERENCES dw.dim_fecha(fecha_sk);


--
-- Name: fact_licitaciones fk_fact_lic_fecha_publicacion; Type: FK CONSTRAINT; Schema: dw; Owner: -
--

ALTER TABLE ONLY dw.fact_licitaciones
    ADD CONSTRAINT fk_fact_lic_fecha_publicacion FOREIGN KEY (fecha_publicacion_sk) REFERENCES dw.dim_fecha(fecha_sk);


--
-- Name: fact_licitaciones fk_fact_lic_organismo; Type: FK CONSTRAINT; Schema: dw; Owner: -
--

ALTER TABLE ONLY dw.fact_licitaciones
    ADD CONSTRAINT fk_fact_lic_organismo FOREIGN KEY (organismo_sk) REFERENCES dw.dim_organismo(organismo_sk);


--
-- Name: fact_licitaciones fk_fact_lic_producto; Type: FK CONSTRAINT; Schema: dw; Owner: -
--

ALTER TABLE ONLY dw.fact_licitaciones
    ADD CONSTRAINT fk_fact_lic_producto FOREIGN KEY (producto_onu_sk) REFERENCES dw.dim_producto_onu(producto_onu_sk);


--
-- Name: fact_licitaciones fk_fact_lic_proveedor; Type: FK CONSTRAINT; Schema: dw; Owner: -
--

ALTER TABLE ONLY dw.fact_licitaciones
    ADD CONSTRAINT fk_fact_lic_proveedor FOREIGN KEY (proveedor_sk) REFERENCES dw.dim_proveedor(proveedor_sk);


--
-- Name: fact_ordenes_compra fk_fact_oc_fecha_aceptacion; Type: FK CONSTRAINT; Schema: dw; Owner: -
--

ALTER TABLE ONLY dw.fact_ordenes_compra
    ADD CONSTRAINT fk_fact_oc_fecha_aceptacion FOREIGN KEY (fecha_aceptacion_sk) REFERENCES dw.dim_fecha(fecha_sk);


--
-- Name: fact_ordenes_compra fk_fact_oc_fecha_creacion; Type: FK CONSTRAINT; Schema: dw; Owner: -
--

ALTER TABLE ONLY dw.fact_ordenes_compra
    ADD CONSTRAINT fk_fact_oc_fecha_creacion FOREIGN KEY (fecha_creacion_sk) REFERENCES dw.dim_fecha(fecha_sk);


--
-- Name: fact_ordenes_compra fk_fact_oc_organismo; Type: FK CONSTRAINT; Schema: dw; Owner: -
--

ALTER TABLE ONLY dw.fact_ordenes_compra
    ADD CONSTRAINT fk_fact_oc_organismo FOREIGN KEY (organismo_sk) REFERENCES dw.dim_organismo(organismo_sk);


--
-- Name: fact_ordenes_compra fk_fact_oc_producto; Type: FK CONSTRAINT; Schema: dw; Owner: -
--

ALTER TABLE ONLY dw.fact_ordenes_compra
    ADD CONSTRAINT fk_fact_oc_producto FOREIGN KEY (producto_onu_sk) REFERENCES dw.dim_producto_onu(producto_onu_sk);


--
-- Name: fact_ordenes_compra fk_fact_oc_proveedor; Type: FK CONSTRAINT; Schema: dw; Owner: -
--

ALTER TABLE ONLY dw.fact_ordenes_compra
    ADD CONSTRAINT fk_fact_oc_proveedor FOREIGN KEY (proveedor_sk) REFERENCES dw.dim_proveedor(proveedor_sk);


--
-- PostgreSQL database dump complete
--

\unrestrict sgyuOq0ekyt9aZU9ulWfVL8sCWy1l1h5YcoV4DHzFDBBSK8NmQf7rhEK85uqO5f

