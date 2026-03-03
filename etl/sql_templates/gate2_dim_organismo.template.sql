-- Gate2: poblar dw.dim_organismo desde STG LIC/OC del periodo tag={{tag}}

WITH src AS (
    SELECT
        NULLIF(TRIM(codigoorganismo), '') AS codigo_organismo,
        NULLIF(TRIM(nombreorganismo), '') AS nombre_organismo,
        NULLIF(TRIM(rutunidad), '') AS rut_organismo,
        NULLIF(TRIM(regionunidad), '') AS region_organismo,
        NULLIF(TRIM(comunaunidad), '') AS comuna_organismo,
        NULLIF(TRIM(sector), '') AS tipo_organismo,
        'LIC'::text AS fuente_preferente
    FROM stg.stg_lic_{{tag}}
    WHERE NULLIF(TRIM(codigoorganismo), '') IS NOT NULL

    UNION ALL

    SELECT
        NULLIF(TRIM(codigoorganismopublico), '') AS codigo_organismo,
        NULLIF(TRIM(organismopublico), '') AS nombre_organismo,
        NULLIF(TRIM(rutunidadcompra), '') AS rut_organismo,
        NULLIF(TRIM(regionunidadcompra), '') AS region_organismo,
        NULLIF(TRIM(ciudadunidadcompra), '') AS comuna_organismo,
        NULLIF(TRIM(sector), '') AS tipo_organismo,
        'OC'::text AS fuente_preferente
    FROM stg.stg_oc_{{tag}}
    WHERE NULLIF(TRIM(codigoorganismopublico), '') IS NOT NULL
),
agg AS (
    SELECT
        codigo_organismo,
        MAX(nombre_organismo) AS nombre_organismo,
        MAX(rut_organismo) AS rut_organismo,
        MAX(region_organismo) AS region_organismo,
        MAX(comuna_organismo) AS comuna_organismo,
        MAX(tipo_organismo) AS tipo_organismo,
        CASE
            WHEN SUM(CASE WHEN fuente_preferente='OC' THEN 1 ELSE 0 END) > 0 THEN 'OC'
            ELSE 'LIC'
        END AS fuente_preferente
    FROM src
    WHERE codigo_organismo IS NOT NULL
    GROUP BY codigo_organismo
)
INSERT INTO dw.dim_organismo
(
  codigo_organismo,
  nombre_organismo,
  rut_organismo,
  region_organismo,
  comuna_organismo,
  tipo_organismo,
  fuente_preferente
)
SELECT
  codigo_organismo,
  nombre_organismo,
  rut_organismo,
  region_organismo,
  comuna_organismo,
  tipo_organismo,
  fuente_preferente
FROM agg
ON CONFLICT (codigo_organismo) DO UPDATE SET
  nombre_organismo  = COALESCE(EXCLUDED.nombre_organismo,  dw.dim_organismo.nombre_organismo),
  rut_organismo     = COALESCE(EXCLUDED.rut_organismo,     dw.dim_organismo.rut_organismo),
  region_organismo  = COALESCE(EXCLUDED.region_organismo,  dw.dim_organismo.region_organismo),
  comuna_organismo  = COALESCE(EXCLUDED.comuna_organismo,  dw.dim_organismo.comuna_organismo),
  tipo_organismo    = COALESCE(EXCLUDED.tipo_organismo,    dw.dim_organismo.tipo_organismo),
  fuente_preferente = CASE
                        WHEN dw.dim_organismo.fuente_preferente IS NULL THEN EXCLUDED.fuente_preferente
                        WHEN dw.dim_organismo.fuente_preferente = 'OC' THEN 'OC'
                        WHEN EXCLUDED.fuente_preferente = 'OC' THEN 'OC'
                        ELSE 'LIC'
                      END;
