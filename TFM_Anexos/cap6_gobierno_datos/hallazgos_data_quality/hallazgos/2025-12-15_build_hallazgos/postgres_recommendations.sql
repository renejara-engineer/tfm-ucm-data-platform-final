-- postgres_recommendations.sql (mínimo viable)
CREATE SCHEMA IF NOT EXISTS stg;
CREATE SCHEMA IF NOT EXISTS clean;
CREATE SCHEMA IF NOT EXISTS dw;
CREATE SCHEMA IF NOT EXISTS meta;

-- Recomendación: cargar todo como TEXT en stg y tipar/normalizar en clean.
