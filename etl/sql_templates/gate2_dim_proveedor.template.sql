-- Gate2: poblar dw.dim_proveedor desde STG LIC/OC del periodo tag={{tag}}

WITH src AS (
    SELECT
        NULLIF(TRIM(codigoproveedor), '') AS codigo_proveedor,
        NULLIF(TRIM(rutproveedor), '') AS rut_proveedor,
        NULLIF(TRIM(nombreproveedor), '') AS nombre_proveedor,
        NULL::text AS region_proveedor,
        NULL::text AS comuna_proveedor,
        NULLIF(TRIM(descripcionproveedor), '') AS tipo_proveedor,
        TRUE::boolean AS es_proveedor_activo,
        'LIC'::text AS fuente_preferente
    FROM stg.stg_lic_{{tag}}
    WHERE NULLIF(TRIM(codigoproveedor), '') IS NOT NULL

    UNION ALL

    SELECT
        NULLIF(TRIM(codigoproveedor), '') AS codigo_proveedor,
        NULL::text AS rut_proveedor,
        NULLIF(TRIM(nombreproveedor), '') AS nombre_proveedor,
        NULLIF(TRIM(regionproveedor), '') AS region_proveedor,
        NULLIF(TRIM(comunaproveedor), '') AS comuna_proveedor,
        NULLIF(TRIM(actividadproveedor), '') AS tipo_proveedor,
        TRUE::boolean AS es_proveedor_activo,
        'OC'::text AS fuente_preferente
    FROM stg.stg_oc_{{tag}}
    WHERE NULLIF(TRIM(codigoproveedor), '') IS NOT NULL
),
agg AS (
    SELECT
        codigo_proveedor,
        MAX(rut_proveedor) AS rut_proveedor,
        MAX(nombre_proveedor) AS nombre_proveedor,
        MAX(region_proveedor) AS region_proveedor,
        MAX(comuna_proveedor) AS comuna_proveedor,
        MAX(tipo_proveedor) AS tipo_proveedor,
        TRUE::boolean AS es_proveedor_activo,
        CASE
            WHEN SUM(CASE WHEN fuente_preferente='OC' THEN 1 ELSE 0 END) > 0 THEN 'OC'
            ELSE 'LIC'
        END AS fuente_preferente
    FROM src
    WHERE codigo_proveedor IS NOT NULL
    GROUP BY codigo_proveedor
)
INSERT INTO dw.dim_proveedor
(
  codigo_proveedor,
  rut_proveedor,
  nombre_proveedor,
  region_proveedor,
  comuna_proveedor,
  tipo_proveedor,
  es_proveedor_activo,
  fuente_preferente
)
SELECT
  codigo_proveedor,
  rut_proveedor,
  nombre_proveedor,
  region_proveedor,
  comuna_proveedor,
  tipo_proveedor,
  es_proveedor_activo,
  fuente_preferente
FROM agg
ON CONFLICT (codigo_proveedor) DO UPDATE SET
  rut_proveedor      = COALESCE(EXCLUDED.rut_proveedor,      dw.dim_proveedor.rut_proveedor),
  nombre_proveedor   = COALESCE(EXCLUDED.nombre_proveedor,   dw.dim_proveedor.nombre_proveedor),
  region_proveedor   = COALESCE(EXCLUDED.region_proveedor,   dw.dim_proveedor.region_proveedor),
  comuna_proveedor   = COALESCE(EXCLUDED.comuna_proveedor,   dw.dim_proveedor.comuna_proveedor),
  tipo_proveedor     = COALESCE(EXCLUDED.tipo_proveedor,     dw.dim_proveedor.tipo_proveedor),
  es_proveedor_activo= COALESCE(EXCLUDED.es_proveedor_activo,dw.dim_proveedor.es_proveedor_activo),
  fuente_preferente  = CASE
                         WHEN dw.dim_proveedor.fuente_preferente IS NULL THEN EXCLUDED.fuente_preferente
                         WHEN dw.dim_proveedor.fuente_preferente = 'OC' THEN 'OC'
                         WHEN EXCLUDED.fuente_preferente = 'OC' THEN 'OC'
                         ELSE 'LIC'
                       END;
