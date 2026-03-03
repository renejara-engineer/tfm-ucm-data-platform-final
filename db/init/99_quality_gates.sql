\set ON_ERROR_STOP on

-- =========================================================
-- 99_quality_gates.sql (CANÓNICO)
-- Validaciones mínimas post-init para blindar el contrato DW + SEM + BI.
-- =========================================================

-- Gate 1: Schemas requeridos
DO $$
DECLARE c int;
BEGIN
  SELECT COUNT(*) INTO c
  FROM pg_namespace
  WHERE nspname IN ('dw','dw_sem');

  IF c <> 2 THEN
    RAISE EXCEPTION 'GATE FAIL: faltan schemas dw y/o dw_sem';
  END IF;
END $$;

-- Gate 2: Tablas DW mínimas (contrato base)
DO $$
DECLARE missing text;
BEGIN
  SELECT string_agg(t.req, ', ') INTO missing
  FROM (
    SELECT unnest(ARRAY[
      'dim_fecha','dim_organismo','dim_producto_onu','dim_proveedor',
      'etl_control_cargas','etl_decisiones_periodo',
      'fact_licitaciones','fact_ordenes_compra'
    ]) AS req
  ) t
  WHERE NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid=c.relnamespace
    WHERE n.nspname='dw' AND c.relname=t.req AND c.relkind='r'
  );

  IF missing IS NOT NULL THEN
    RAISE EXCEPTION 'GATE FAIL: faltan tablas en dw: %', missing;
  END IF;
END $$;

-- Gate 3: Vistas SEM mínimas (contrato analítico)
DO $$
DECLARE missing text;
BEGIN
  SELECT string_agg(v.req, ', ') INTO missing
  FROM (
    SELECT unnest(ARRAY[
      'v_cruce_lic_oc_lag_v1',
      'v_dim_organismo_sem','v_dim_organismo_sem_v2',
      'v_fact_licitaciones_sem','v_fact_licitaciones_sem_v2',
      'v_fact_ordenes_compra_sem','v_fact_ordenes_compra_sem_v2'
    ]) AS req
  ) v
  WHERE NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid=c.relnamespace
    WHERE n.nspname='dw_sem' AND c.relname=v.req AND c.relkind='v'
  );

  IF missing IS NOT NULL THEN
    RAISE EXCEPTION 'GATE FAIL: faltan vistas en dw_sem: %', missing;
  END IF;
END $$;

-- Gate 4: Contrato Power BI (_sem_v2 mínimo)
DO $$
DECLARE c int;
BEGIN
  SELECT COUNT(*) INTO c
  FROM pg_class c
  JOIN pg_namespace n ON n.oid=c.relnamespace
  WHERE n.nspname='dw_sem' AND c.relkind='v'
    AND c.relname LIKE '%\_sem\_v2' ESCAPE '\';

  IF c < 3 THEN
    RAISE EXCEPTION 'GATE FAIL: contrato BI roto, vistas *_sem_v2 encontradas=% (esperado>=3)', c;
  END IF;
END $$;

-- Gate 5: dim_fecha poblada y llave natural única
DO $$
DECLARE c bigint;
DECLARE has_uq boolean;
BEGIN
  EXECUTE 'SELECT COUNT(*) FROM dw.dim_fecha' INTO c;
  IF c < 2191 THEN
    RAISE EXCEPTION 'GATE FAIL: dim_fecha insuficiente. Filas=% (esperado >= 2191 para rango 2022-01-01..2027-12-31).', c;
  END IF;

  SELECT EXISTS (
    SELECT 1
    FROM pg_constraint con
    JOIN pg_class rel ON rel.oid = con.conrelid
    JOIN pg_namespace nsp ON nsp.oid = rel.relnamespace
    WHERE nsp.nspname='dw' AND rel.relname='dim_fecha'
      AND con.contype='u'
      AND pg_get_constraintdef(con.oid) ILIKE '%(fecha)%'
  ) INTO has_uq;

  IF NOT has_uq THEN
    RAISE EXCEPTION 'GATE FAIL: falta UNIQUE(fecha) en dw.dim_fecha (requerido para seed idempotente y cargas incrementales).';
  END IF;
END $$;

-- Gate 6: Sanity counts (no exige igualdad, detecta incoherencias graves)
DO $$
DECLARE lic_dw bigint; lic_sem bigint;
DECLARE oc_dw bigint;  oc_sem bigint;
BEGIN
  EXECUTE 'SELECT COUNT(*) FROM dw.fact_licitaciones' INTO lic_dw;
  EXECUTE 'SELECT COUNT(*) FROM dw_sem.v_fact_licitaciones_sem_v2' INTO lic_sem;

  IF lic_dw > 0 AND lic_sem = 0 THEN
    RAISE EXCEPTION 'GATE FAIL: v_fact_licitaciones_sem_v2 vacía pero fact_licitaciones tiene datos (%).', lic_dw;
  END IF;

  EXECUTE 'SELECT COUNT(*) FROM dw.fact_ordenes_compra' INTO oc_dw;
  EXECUTE 'SELECT COUNT(*) FROM dw_sem.v_fact_ordenes_compra_sem_v2' INTO oc_sem;

  IF oc_dw > 0 AND oc_sem = 0 THEN
    RAISE EXCEPTION 'GATE FAIL: v_fact_ordenes_compra_sem_v2 vacía pero fact_ordenes_compra tiene datos (%).', oc_dw;
  END IF;

  RAISE NOTICE 'SANITY OK: LIC dw=% sem_v2=% | OC dw=% sem_v2=%', lic_dw, lic_sem, oc_dw, oc_sem;
END $$;
