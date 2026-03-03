-- SQL_CONTRASTE_KPIS_FASE7.sql
-- Fase 7: Auditoría BI y trazabilidad DW→DAX→KPI (Gate BI-1)
-- Fuente DAX: TFM_BI_ChileCompra_medidas_dax.tsv (64 medidas exportadas)
-- Importante: este script asume que las vistas DW contienen la columna moneda_norm.
-- Si no existe, el precheck lo mostrará y debe ajustarse (NO CONSTA hasta corregir).

\set ON_ERROR_STOP on

-- ================
-- 0) PRECHECK
-- ================
-- Columnas disponibles en vistas usadas por KPIs core (verificar moneda_norm y campos base)
SELECT table_schema, table_name, column_name, data_type
FROM information_schema.columns
WHERE (table_schema, table_name) IN (('dw_sem','v_fact_licitaciones_sem_v2'),
                                     ('dw_sem','v_fact_ordenes_compra_sem_v2'))
ORDER BY table_schema, table_name, ordinal_position;

-- Monedas disponibles (para que ejecutes por cada una sin inventar lista)
SELECT 'LIC' AS universo, moneda_norm, COUNT(*) AS filas
FROM dw_sem.v_fact_licitaciones_sem_v2
GROUP BY moneda_norm
ORDER BY moneda_norm;

SELECT 'OC' AS universo, moneda_norm, COUNT(*) AS filas
FROM dw_sem.v_fact_ordenes_compra_sem_v2
GROUP BY moneda_norm
ORDER BY moneda_norm;

-- ================
-- 1) TABLA RESULTADOS
-- ================
DROP TABLE IF EXISTS tmp_kpi_sql_results;
CREATE TEMP TABLE tmp_kpi_sql_results(
  dashboard text,
  kpi text,
  medida_dax text,
  moneda_norm text,
  valor_sql numeric,
  sql_text text
);

-- Parametrización: ejecuta el script múltiples veces cambiando este valor.
-- Ejemplo en psql: \set moneda_norm 'CLP'
\if :{?moneda_norm}
\else
\echo 'ERROR: debe definir :moneda_norm. Ejemplo: \set moneda_norm ''CLP'''
\quit
\endif

-- ================
-- 2) KPIs CORE (10)
-- ================

-- LIC N° Licitaciones  (Medida: SEM LIC N° Licitaciones)
INSERT INTO tmp_kpi_sql_results
SELECT 'LIC',
       'LIC N° Licitaciones',
       'SEM LIC N° Licitaciones',
       :moneda_norm,
       (SELECT COUNT(*)::numeric FROM dw_sem.v_fact_licitaciones_sem_v2 WHERE moneda_norm = :moneda_norm),
       $$SELECT COUNT(*) FROM dw_sem.v_fact_licitaciones_sem_v2 WHERE moneda_norm = :moneda_norm;$$;

-- LIC Monto Adjudicado (Medida: SEM LIC Monto Adjudicado)
INSERT INTO tmp_kpi_sql_results
SELECT 'LIC',
       'LIC Monto Adjudicado',
       'SEM LIC Monto Adjudicado',
       :moneda_norm,
       (SELECT COALESCE(SUM(monto_adjudicado),0)::numeric FROM dw_sem.v_fact_licitaciones_sem_v2 WHERE moneda_norm = :moneda_norm),
       $$SELECT COALESCE(SUM(monto_adjudicado),0) FROM dw_sem.v_fact_licitaciones_sem_v2 WHERE moneda_norm = :moneda_norm;$$;

-- LIC Monto Estimado (Medida: SEM LIC Monto Estimado)
-- Traducción de DAX: SUMX(VALUES(licitacion_sk), CALCULATE(MAX(monto_estimado), flags=0))
INSERT INTO tmp_kpi_sql_results
SELECT 'LIC',
       'LIC Monto Estimado',
       'SEM LIC Monto Estimado',
       :moneda_norm,
       (SELECT COALESCE(SUM(monto_estimado_max),0)::numeric
        FROM (
          SELECT licitacion_sk, MAX(monto_estimado) AS monto_estimado_max
          FROM dw_sem.v_fact_licitaciones_sem_v2
          WHERE moneda_norm = :moneda_norm
            AND flag_monto_estimado_anom = 0
            AND flag_moneda_missing = 0
            AND flag_moneda_unknown = 0
          GROUP BY licitacion_sk
        ) t),
       $$SELECT COALESCE(SUM(monto_estimado_max),0)
         FROM (
           SELECT licitacion_sk, MAX(monto_estimado) AS monto_estimado_max
           FROM dw_sem.v_fact_licitaciones_sem_v2
           WHERE moneda_norm = :moneda_norm
             AND flag_monto_estimado_anom = 0
             AND flag_moneda_missing = 0
             AND flag_moneda_unknown = 0
           GROUP BY licitacion_sk
         ) t;$$;

-- LIC Proveedores Distintos (Medida: SEM LIC Proveedores Distintos)
INSERT INTO tmp_kpi_sql_results
SELECT 'LIC',
       'LIC Proveedores Distintos',
       'SEM LIC Proveedores Distintos',
       :moneda_norm,
       (SELECT COUNT(DISTINCT proveedor_sk)::numeric FROM dw_sem.v_fact_licitaciones_sem_v2 WHERE moneda_norm = :moneda_norm),
       $$SELECT COUNT(DISTINCT proveedor_sk) FROM dw_sem.v_fact_licitaciones_sem_v2 WHERE moneda_norm = :moneda_norm;$$;

-- LIC Productos ONU Distintos (Medida: SEM LIC Productos ONU Distintos)
INSERT INTO tmp_kpi_sql_results
SELECT 'LIC',
       'LIC Productos ONU Distintos',
       'SEM LIC Productos ONU Distintos',
       :moneda_norm,
       (SELECT COUNT(DISTINCT producto_onu_sk)::numeric FROM dw_sem.v_fact_licitaciones_sem_v2 WHERE moneda_norm = :moneda_norm),
       $$SELECT COUNT(DISTINCT producto_onu_sk) FROM dw_sem.v_fact_licitaciones_sem_v2 WHERE moneda_norm = :moneda_norm;$$;

-- OC N° Ordenes Compra (Medida: OC #)
INSERT INTO tmp_kpi_sql_results
SELECT 'OC',
       'OC N° Ordenes Compra',
       'OC #',
       :moneda_norm,
       (SELECT COUNT(*)::numeric FROM dw_sem.v_fact_ordenes_compra_sem_v2 WHERE moneda_norm = :moneda_norm),
       $$SELECT COUNT(*) FROM dw_sem.v_fact_ordenes_compra_sem_v2 WHERE moneda_norm = :moneda_norm;$$;

-- OC Monto (moneda única) (Medida: OC Monto (moneda unica))
INSERT INTO tmp_kpi_sql_results
SELECT 'OC',
       'OC Monto (moneda única)',
       'OC Monto (moneda unica)',
       :moneda_norm,
       (SELECT COALESCE(SUM(monto_total),0)::numeric FROM dw_sem.v_fact_ordenes_compra_sem_v2 WHERE moneda_norm = :moneda_norm),
       $$SELECT COALESCE(SUM(monto_total),0) FROM dw_sem.v_fact_ordenes_compra_sem_v2 WHERE moneda_norm = :moneda_norm;$$;

-- OC Proveedores Distintos (Medida: OC Proveedores)
INSERT INTO tmp_kpi_sql_results
SELECT 'OC',
       'OC Proveedores Distintos',
       'OC Proveedores',
       :moneda_norm,
       (SELECT COUNT(DISTINCT proveedor_sk)::numeric FROM dw_sem.v_fact_ordenes_compra_sem_v2 WHERE moneda_norm = :moneda_norm),
       $$SELECT COUNT(DISTINCT proveedor_sk) FROM dw_sem.v_fact_ordenes_compra_sem_v2 WHERE moneda_norm = :moneda_norm;$$;

-- OC Productos ONU Distintos (Medida: OC Productos ONU Distintos)
INSERT INTO tmp_kpi_sql_results
SELECT 'OC',
       'OC Productos ONU Distintos',
       'OC Productos ONU Distintos',
       :moneda_norm,
       (SELECT COUNT(DISTINCT producto_onu_sk)::numeric FROM dw_sem.v_fact_ordenes_compra_sem_v2 WHERE moneda_norm = :moneda_norm),
       $$SELECT COUNT(DISTINCT producto_onu_sk) FROM dw_sem.v_fact_ordenes_compra_sem_v2 WHERE moneda_norm = :moneda_norm;$$;

-- OC Organismos Distintos (Medida: OC Organismos Distintos)
INSERT INTO tmp_kpi_sql_results
SELECT 'OC',
       'OC Organismos Distintos',
       'OC Organismos Distintos',
       :moneda_norm,
       (SELECT COUNT(DISTINCT organismo_sk)::numeric FROM dw_sem.v_fact_ordenes_compra_sem_v2 WHERE moneda_norm = :moneda_norm),
       $$SELECT COUNT(DISTINCT organismo_sk) FROM dw_sem.v_fact_ordenes_compra_sem_v2 WHERE moneda_norm = :moneda_norm;$$;

-- ================
-- 3) SALIDA
-- ================
SELECT * FROM tmp_kpi_sql_results ORDER BY dashboard, kpi;

-- Export (psql):
-- \copy (SELECT dashboard,kpi,medida_dax,moneda_norm,valor_sql FROM tmp_kpi_sql_results ORDER BY dashboard,kpi)
-- TO 'RESULTADOS_SQL_KPIS.csv' WITH (FORMAT csv, HEADER true);

