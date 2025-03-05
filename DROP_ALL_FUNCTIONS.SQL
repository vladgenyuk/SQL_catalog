DO $$ 
BEGIN
  EXECUTE (
    SELECT string_agg(format('DROP FUNCTION IF EXISTS %s(%s);', 
                             n.nspname || '.' || p.proname, 
                             pg_get_function_identity_arguments(p.oid)), 
                      E'\n')
    FROM pg_proc p
      JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE n.nspname NOT IN ('pg_catalog', 'information_schema') -- Exclude system schemas
      AND p.proisagg = FALSE -- Exclude aggregate functions
  );
END $$;




DO $$ 
DECLARE
  r RECORD;
BEGIN
  FOR r IN
    SELECT event_object_table AS table_name, 
           trigger_name 
    FROM information_schema.triggers
  LOOP
    EXECUTE format('DROP TRIGGER IF EXISTS %I ON %I;', r.trigger_name, r.table_name);
  END LOOP;
END $$;
