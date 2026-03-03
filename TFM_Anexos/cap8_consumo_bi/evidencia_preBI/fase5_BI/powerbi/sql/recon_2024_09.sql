-- RECON BI-1 vs DW (ancla 2024-09)
-- LIC (por periodo)
SELECT 'LIC_cnt' AS metric, COUNT(*)::bigint AS valor
FROM dw.fact_licitaciones
WHERE periodo = '2024-09'
UNION ALL
SELECT 'LIC_monto_adjudicado' AS metric, COALESCE(SUM(monto_adjudicado),0)::numeric AS valor
FROM dw.fact_licitaciones
WHERE periodo = '2024-09'
UNION ALL
-- OC (por periodo)
SELECT 'OC_cnt' AS metric, COUNT(*)::bigint AS valor
FROM dw.fact_ordenes_compra
WHERE periodo = '2024-09'
UNION ALL
SELECT 'OC_monto_total' AS metric, COALESCE(SUM(monto_total),0)::numeric AS valor
FROM dw.fact_ordenes_compra
WHERE periodo = '2024-09';
