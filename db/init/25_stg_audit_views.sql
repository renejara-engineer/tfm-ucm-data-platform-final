\set ON_ERROR_STOP on

-- ============================================================
-- STG Audit View (Option A): Dynamic by pattern in schema `stg`
-- Purpose:
--   - Inspect column structure for monthly staging tables:
--       stg.stg_lic_YYYY_MM, stg.stg_oc_YYYY_MM
--   - Keep `public` clean; staging objects live in schema `stg`
-- ============================================================

CREATE SCHEMA IF NOT EXISTS stg;

CREATE OR REPLACE VIEW stg.vw_audit_staging_lic_oc AS
SELECT
  c.table_schema,
  c.table_name,
  c.column_name,
  c.data_type,
  c.is_nullable,
  c.ordinal_position
FROM information_schema.columns c
WHERE c.table_schema = 'stg'
  AND (
    c.table_name ~ '^stg_lic_[0-9]{4}_[0-9]{2}$'
    OR c.table_name ~ '^stg_oc_[0-9]{4}_[0-9]{2}$'
  )
ORDER BY c.table_schema, c.table_name, c.ordinal_position;

ALTER VIEW stg.vw_audit_staging_lic_oc OWNER TO chile_user;
