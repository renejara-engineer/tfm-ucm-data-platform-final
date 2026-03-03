WITH lic_raw AS (
  SELECT
    (codigoexterno || '|' ||
     COALESCE(NULLIF(codigoproveedor,''),'NA') || '|' ||
     COALESCE(NULLIF(codigoproductoonu,''),'NA') || '|' ||
     COALESCE(NULLIF(codigoitem,''),'NA') || '|' ||
     COALESCE(NULLIF(correlativo,''),'NA')
    ) AS licitacion_bk,
    '{{period}}'::text AS periodo,

    NULLIF(codigoorganismo,'')   AS codigo_organismo,
    NULLIF(codigoproveedor,'')   AS codigo_proveedor,
    NULLIF(codigoproductoonu,'') AS codigo_producto_onu,

    CASE WHEN fechapublicacion ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
         THEN substring(fechapublicacion,1,10)::date END AS fecha_publicacion,
    CASE WHEN fechacierre ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
         THEN substring(fechacierre,1,10)::date END AS fecha_cierre,

    NULLIF(estado,'')              AS estado_licitacion,
    NULLIF(tipo_de_adquisicion,'') AS tipo_adquisicion,
    NULLIF(moneda_adquisicion,'')  AS moneda,

    NULLIF(montoestimado,'')              AS monto_estimado_txt,
    NULLIF(monto_estimado_adjudicado,'')  AS monto_adjudicado_txt,
    NULLIF(numerooferentes,'')            AS numerooferentes_txt
  FROM stg.stg_lic_{{tag}}
  WHERE codigoexterno IS NOT NULL AND codigoexterno <> ''
),
lic_aggr AS (
  SELECT
    licitacion_bk,
    periodo,
    MAX(codigo_organismo) AS codigo_organismo,
    MAX(codigo_proveedor) AS codigo_proveedor,
    MAX(codigo_producto_onu) AS codigo_producto_onu,

    MIN(fecha_publicacion) AS fecha_publicacion,
    MIN(fecha_cierre) AS fecha_cierre,

    MAX(estado_licitacion) AS estado_licitacion,
    MAX(tipo_adquisicion) AS tipo_adquisicion,
    MAX(moneda) AS moneda,

    MAX(NULLIF(regexp_replace(monto_estimado_txt,   '[^0-9\\.-]', '', 'g'), '')::numeric(18,2)) AS monto_estimado,
    MAX(NULLIF(regexp_replace(monto_adjudicado_txt, '[^0-9\\.-]', '', 'g'), '')::numeric(18,2)) AS monto_adjudicado,
    MAX(NULLIF(regexp_replace(numerooferentes_txt,  '[^0-9\\.-]', '', 'g'), '')::numeric)::int  AS cantidad_oferentes,

    1 AS cantidad_items
  FROM lic_raw
  GROUP BY licitacion_bk, periodo
)
INSERT INTO dw.fact_licitaciones
(licitacion_bk, fecha_publicacion_sk, fecha_cierre_sk, organismo_sk, proveedor_sk, producto_onu_sk,
 monto_estimado, monto_adjudicado, cantidad_oferentes, cantidad_items, estado_licitacion, tipo_adquisicion, moneda,
 periodo, source_file)
SELECT
  a.licitacion_bk,
  dfp.fecha_sk AS fecha_publicacion_sk,
  dfc.fecha_sk AS fecha_cierre_sk,
  org.organismo_sk,
  prov.proveedor_sk,
  prod.producto_onu_sk,

  a.monto_estimado,
  a.monto_adjudicado,
  a.cantidad_oferentes,
  a.cantidad_items,
  a.estado_licitacion,
  a.tipo_adquisicion,
  a.moneda,
  a.periodo,
  'stg_lic_{{tag}}'::text AS source_file
FROM lic_aggr a
JOIN dw.dim_organismo org     ON org.codigo_organismo = a.codigo_organismo
JOIN dw.dim_proveedor prov    ON prov.codigo_proveedor = a.codigo_proveedor
JOIN dw.dim_producto_onu prod ON prod.codigo_producto_onu = a.codigo_producto_onu
JOIN dw.dim_fecha dfp         ON dfp.fecha = a.fecha_publicacion
LEFT JOIN dw.dim_fecha dfc    ON dfc.fecha = a.fecha_cierre
ON CONFLICT (licitacion_bk, periodo) DO UPDATE
SET
  fecha_publicacion_sk = EXCLUDED.fecha_publicacion_sk,
  fecha_cierre_sk      = EXCLUDED.fecha_cierre_sk,
  organismo_sk         = EXCLUDED.organismo_sk,
  proveedor_sk         = EXCLUDED.proveedor_sk,
  producto_onu_sk      = EXCLUDED.producto_onu_sk,
  monto_estimado       = EXCLUDED.monto_estimado,
  monto_adjudicado     = EXCLUDED.monto_adjudicado,
  cantidad_oferentes   = EXCLUDED.cantidad_oferentes,
  cantidad_items       = EXCLUDED.cantidad_items,
  estado_licitacion    = EXCLUDED.estado_licitacion,
  tipo_adquisicion     = EXCLUDED.tipo_adquisicion,
  moneda               = EXCLUDED.moneda,
  source_file          = EXCLUDED.source_file;
