\set ON_ERROR_STOP on

-- Permisos mínimos para compatibilidad Power BI (usuario de conexión: chile_user)
GRANT USAGE ON SCHEMA dw TO chile_user;
GRANT USAGE ON SCHEMA dw_sem TO chile_user;

GRANT SELECT ON ALL TABLES IN SCHEMA dw TO chile_user;
GRANT SELECT ON ALL TABLES IN SCHEMA dw_sem TO chile_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA dw
  GRANT SELECT ON TABLES TO chile_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA dw_sem
  GRANT SELECT ON TABLES TO chile_user;

-- Staging schema (Option A): ETL creates monthly STG tables here
GRANT USAGE, CREATE ON SCHEMA stg TO chile_user;
GRANT SELECT ON ALL TABLES IN SCHEMA stg TO chile_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA stg
  GRANT SELECT ON TABLES TO chile_user;

-- If any ETL role inserts into identity columns (not typical for BI), allow sequences too
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA dw TO chile_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA stg TO chile_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA dw
  GRANT USAGE, SELECT ON SEQUENCES TO chile_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA stg
  GRANT USAGE, SELECT ON SEQUENCES TO chile_user;
