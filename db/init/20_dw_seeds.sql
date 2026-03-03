\set ON_ERROR_STOP on

-- =========================================================
-- 20_dw_seeds.sql (CANÓNICO)
-- Seeds mínimos indispensables para operación y BI.
-- - dim_fecha: calendario robusto (rango fijo y defendible).
-- =========================================================

-- ============================
-- Seed dimensión calendario (dw.dim_fecha)
-- Rango fijo: 2022-01-01 .. 2027-12-31
-- Nota: requiere constraint UNIQUE(fecha) o PK(fecha).
-- ============================
INSERT INTO dw.dim_fecha
(fecha, anio, mes, dia, trimestre, nombre_mes, nombre_dia_semana, es_fin_de_semana)
SELECT
  d::date AS fecha,
  EXTRACT(YEAR    FROM d)::smallint AS anio,
  EXTRACT(MONTH   FROM d)::smallint AS mes,
  EXTRACT(DAY     FROM d)::smallint AS dia,
  EXTRACT(QUARTER FROM d)::smallint AS trimestre,
  to_char(d, 'TMMonth') AS nombre_mes,
  to_char(d, 'TMDay')   AS nombre_dia_semana,
  (EXTRACT(ISODOW FROM d) IN (6,7)) AS es_fin_de_semana
FROM generate_series('2022-01-01'::date, '2027-12-31'::date, '1 day'::interval) AS d
ON CONFLICT (fecha) DO NOTHING;

-- ============================
-- TODO (si aplica): catálogos mínimos adicionales (ONU, etc.)
-- ============================
