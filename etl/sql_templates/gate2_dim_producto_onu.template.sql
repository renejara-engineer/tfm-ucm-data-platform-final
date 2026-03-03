-- Gate2: poblar dw.dim_producto_onu desde STG LIC/OC del periodo tag={{tag}}

WITH src AS (
    SELECT
        NULLIF(TRIM(codigoproductoonu), '') AS codigo_producto_onu,
        NULLIF(TRIM(nombre_producto_genrico), '') AS descripcion_producto_onu,
        NULLIF(TRIM(rubro1), '') AS rubro_n1,
        NULLIF(TRIM(rubro2), '') AS rubro_n2,
        NULLIF(TRIM(rubro3), '') AS rubro_n3,
        NULLIF(TRIM(unidadmedida), '') AS unidad_medida,
        TRUE::boolean AS es_producto_valido
    FROM stg.stg_lic_{{tag}}
    WHERE NULLIF(TRIM(codigoproductoonu), '') IS NOT NULL

    UNION ALL

    SELECT
        NULLIF(TRIM(codigoproductoonu), '') AS codigo_producto_onu,
        NULLIF(TRIM(nombreroductogenerico), '') AS descripcion_producto_onu,
        NULLIF(TRIM(rubron1), '') AS rubro_n1,
        NULLIF(TRIM(rubron2), '') AS rubro_n2,
        NULLIF(TRIM(rubron3), '') AS rubro_n3,
        NULLIF(TRIM(unidadmedida), '') AS unidad_medida,
        TRUE::boolean AS es_producto_valido
    FROM stg.stg_oc_{{tag}}
    WHERE NULLIF(TRIM(codigoproductoonu), '') IS NOT NULL
),
agg AS (
    SELECT
        codigo_producto_onu,
        MAX(descripcion_producto_onu) AS descripcion_producto_onu,
        MAX(rubro_n1) AS rubro_n1,
        MAX(rubro_n2) AS rubro_n2,
        MAX(rubro_n3) AS rubro_n3,
        MAX(unidad_medida) AS unidad_medida,
        TRUE::boolean AS es_producto_valido
    FROM src
    WHERE codigo_producto_onu IS NOT NULL
    GROUP BY codigo_producto_onu
)
INSERT INTO dw.dim_producto_onu
(
  codigo_producto_onu,
  descripcion_producto_onu,
  rubro_n1,
  rubro_n2,
  rubro_n3,
  unidad_medida,
  es_producto_valido
)
SELECT
  codigo_producto_onu,
  descripcion_producto_onu,
  rubro_n1,
  rubro_n2,
  rubro_n3,
  unidad_medida,
  es_producto_valido
FROM agg
ON CONFLICT (codigo_producto_onu) DO UPDATE SET
  descripcion_producto_onu = COALESCE(EXCLUDED.descripcion_producto_onu, dw.dim_producto_onu.descripcion_producto_onu),
  rubro_n1                 = COALESCE(EXCLUDED.rubro_n1,                 dw.dim_producto_onu.rubro_n1),
  rubro_n2                 = COALESCE(EXCLUDED.rubro_n2,                 dw.dim_producto_onu.rubro_n2),
  rubro_n3                 = COALESCE(EXCLUDED.rubro_n3,                 dw.dim_producto_onu.rubro_n3),
  unidad_medida            = COALESCE(EXCLUDED.unidad_medida,            dw.dim_producto_onu.unidad_medida),
  es_producto_valido       = COALESCE(EXCLUDED.es_producto_valido,       dw.dim_producto_onu.es_producto_valido);
