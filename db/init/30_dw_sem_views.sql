\set ON_ERROR_STOP on

-- Name: dw_sem; Type: SCHEMA; Schema: -; Owner: chile_user
--

CREATE SCHEMA IF NOT EXISTS dw_sem;


ALTER SCHEMA dw_sem OWNER TO chile_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--

-- Name: v_dim_organismo_sem_v2; Type: VIEW; Schema: dw_sem; Owner: chile_user
--

CREATE OR REPLACE VIEW dw_sem.v_dim_organismo_sem_v2 AS
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


ALTER TABLE dw_sem.v_dim_organismo_sem_v2 OWNER TO chile_user;

--

-- Name: v_dim_organismo_sem; Type: VIEW; Schema: dw_sem; Owner: chile_user
--

CREATE OR REPLACE VIEW dw_sem.v_dim_organismo_sem AS
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


ALTER TABLE dw_sem.v_dim_organismo_sem OWNER TO chile_user;

--

-- Name: v_fact_licitaciones_sem; Type: VIEW; Schema: dw_sem; Owner: chile_user
--

CREATE OR REPLACE VIEW dw_sem.v_fact_licitaciones_sem AS
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


ALTER TABLE dw_sem.v_fact_licitaciones_sem OWNER TO chile_user;

--

-- Name: v_fact_licitaciones_sem_v2; Type: VIEW; Schema: dw_sem; Owner: chile_user
--

CREATE OR REPLACE VIEW dw_sem.v_fact_licitaciones_sem_v2 AS
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


ALTER TABLE dw_sem.v_fact_licitaciones_sem_v2 OWNER TO chile_user;

--

-- Name: v_fact_ordenes_compra_sem_v2; Type: VIEW; Schema: dw_sem; Owner: chile_user
--

CREATE OR REPLACE VIEW dw_sem.v_fact_ordenes_compra_sem_v2 AS
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


ALTER TABLE dw_sem.v_fact_ordenes_compra_sem_v2 OWNER TO chile_user;

--

-- Name: v_cruce_lic_oc_lag_v1; Type: VIEW; Schema: dw_sem; Owner: chile_user
--

CREATE OR REPLACE VIEW dw_sem.v_cruce_lic_oc_lag_v1 AS
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


ALTER TABLE dw_sem.v_cruce_lic_oc_lag_v1 OWNER TO chile_user;

--

-- Name: v_fact_ordenes_compra_sem; Type: VIEW; Schema: dw_sem; Owner: chile_user
--

CREATE OR REPLACE VIEW dw_sem.v_fact_ordenes_compra_sem AS
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


ALTER TABLE dw_sem.v_fact_ordenes_compra_sem OWNER TO chile_user;

--