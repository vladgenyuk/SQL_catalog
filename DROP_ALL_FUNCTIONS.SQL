-- Drop all triggers
DO $$ 
DECLARE
    triggername TEXT;
    tablename TEXT;
    stmt TEXT;
BEGIN
    FOR triggername, tablename IN 
        SELECT trigger_name, event_object_table
        FROM information_schema.triggers
        WHERE trigger_schema = 'public'
    LOOP
        stmt := 'DROP TRIGGER IF EXISTS ' || quote_ident(triggername) || ' ON ' || quote_ident(tablename) || ' CASCADE;';
        EXECUTE stmt;
    END LOOP;
END $$;

-- Drop all functions
DO $$
DECLARE
    funcname TEXT;
    funcargs TEXT;
    stmt TEXT;
BEGIN
    FOR funcname, funcargs IN
        SELECT p.proname, pg_get_function_identity_arguments(p.oid)
        FROM pg_proc p
        JOIN pg_namespace n ON p.pronamespace = n.oid
        WHERE n.nspname = 'public'
    LOOP
        stmt := 'DROP FUNCTION IF EXISTS ' || quote_ident(funcname) || '(' || funcargs || ') CASCADE;';
        EXECUTE stmt;
    END LOOP;
END $$;
