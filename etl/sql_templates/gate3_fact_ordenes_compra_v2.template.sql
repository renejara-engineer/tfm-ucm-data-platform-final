/*
Gate 3 — Fact OC (Periodo 2024-10)
Corrección: parseo numérico con coma decimal (fuente ChileCompra).
Regla:
- Si montototaloc = '^\d+,\d+$' -> coma es decimal -> reemplazar por punto y castear.
- Si montototaloc = '^\d+$'     -> entero -> castear directo.
- Otros formatos -> NULL (se registran como calidad de dato a nivel documental).
*/

WITH oc_base AS (
  SELECT
    (codigo || '|' ||
     COALESCE(NULLIF(codigoproveedor,''),'NA') || '|' ||
     COALESCE(NULLIF(codigoproductoonu,''),'NA') || '|' ||
     COALESCE(NULLIF(iditem,''),'NA')
    ) AS orden_compra_bk,

    '{{period}}'::text AS periodo,

    NULLIF(codigoorganismopublico,'') AS codigo_organismo,
    NULLIF(codigoproveedor,'')        AS codigo_proveedor,
    NULLIF(codigoproductoonu,'')      AS codigo_producto_onu,

    CASE WHEN fechacreacion ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
         THEN substring(fechacreacion,1,10)::date END AS fecha_creacion,

    CASE WHEN fechaaceptacion ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
         THEN substring(fechaaceptacion,1,10)::date END AS fecha_aceptacion,

    NULLIF(estado,'')            AS estado_oc,
    NULLIF(descripciontipooc,'') AS tipo_oc,
    NULLIF(tipomonedaoc,'')      AS moneda,

    NULLIF(montototaloc,'')      AS montototaloc_txt,
    NULLIF(cantidad,'')          AS cantidad_txt

  FROM stg.stg_oc_{{tag}}
  WHERE codigo IS NOT NULL AND codigo <> ''
),
oc_cast AS (
  SELECT
    orden_compra_bk,
    periodo,
    codigo_organismo,
    codigo_proveedor,
    codigo_producto_onu,
    fecha_creacion,
    fecha_aceptacion,
    estado_oc,
    tipo_oc,
    moneda,

    CASE
      WHEN montototaloc_txt ~ '^[0-9]+,[0-9]+$'
        THEN round(replace(montototaloc_txt, ',', '.')::numeric, 2)
      WHEN montototaloc_txt ~ '^[0-9]+$'
        THEN montototaloc_txt::numeric(18,2)
      ELSE NULL
    END AS monto_total,

    CASE
      WHEN cantidad_txt ~ '^[0-9]+,[0-9]+$'
        THEN round(replace(cantidad_txt, ',', '.')::numeric, 2)
      WHEN cantidad_txt ~ '^[0-9]+$'
        THEN cantidad_txt::numeric(18,2)
      ELSE NULL
    END AS cantidad_total

  FROM oc_base
)
INSERT INTO dw.fact_ordenes_compra
(orden_compra_bk, fecha_creacion_sk, fecha_aceptacion_sk, organismo_sk, proveedor_sk, producto_onu_sk,
 monto_total, cantidad_total, cantidad_items, estado_oc, tipo_oc, moneda, periodo, source_file)
SELECT
  b.orden_compra_bk,
  dfc.fecha_sk AS fecha_creacion_sk,
  dfa.fecha_sk AS fecha_aceptacion_sk,
  org.organismo_sk,
  prov.proveedor_sk,
  prod.producto_onu_sk,
  b.monto_total,
  b.cantidad_total,
  1 AS cantidad_items,
  b.estado_oc,
  b.tipo_oc,
  b.moneda,
  b.periodo,
  'stg_oc_{{tag}}'::text AS source_file
FROM oc_cast b
JOIN dw.dim_organismo org     ON org.codigo_organismo = b.codigo_organismo
JOIN dw.dim_proveedor prov    ON prov.codigo_proveedor = b.codigo_proveedor
JOIN dw.dim_producto_onu prod ON prod.codigo_producto_onu = b.codigo_producto_onu
JOIN dw.dim_fecha dfc         ON dfc.fecha = b.fecha_creacion
LEFT JOIN dw.dim_fecha dfa    ON dfa.fecha = b.fecha_aceptacion
ON CONFLICT (orden_compra_bk, periodo) DO UPDATE
SET
  fecha_creacion_sk   = EXCLUDED.fecha_creacion_sk,
  fecha_aceptacion_sk = EXCLUDED.fecha_aceptacion_sk,
  organismo_sk        = EXCLUDED.organismo_sk,
  proveedor_sk        = EXCLUDED.proveedor_sk,
  producto_onu_sk     = EXCLUDED.producto_onu_sk,
  monto_total         = EXCLUDED.monto_total,
  cantidad_total      = EXCLUDED.cantidad_total,
  cantidad_items      = EXCLUDED.cantidad_items,
  estado_oc           = EXCLUDED.estado_oc,
  tipo_oc             = EXCLUDED.tipo_oc,
  moneda              = EXCLUDED.moneda,
  source_file         = EXCLUDED.source_file;
