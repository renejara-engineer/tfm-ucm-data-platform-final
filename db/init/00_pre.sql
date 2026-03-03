\set ON_ERROR_STOP on

-- ============================================================
-- 00_pre.sql
-- Purpose:
--   - Create required schemas for the ChileCompra DW
--   - Keep `public` clean (staging lives in `stg`)
-- Notes:
--   - This file must run before 10_dw_schema.sql
-- ============================================================

CREATE SCHEMA IF NOT EXISTS dw;
CREATE SCHEMA IF NOT EXISTS dw_sem;
CREATE SCHEMA IF NOT EXISTS stg;

-- Optional: ensure consistent locale for month/day names if you use to_char with TMMonth/TMDay
-- (uncomment if your instance has this locale installed)
-- SET lc_time = 'es_ES.UTF-8';
