DO $do$
DECLARE
    _sql text;
BEGIN
    SELECT string_agg('DROP FUNCTION ' || oid::regproc::text || ';', E'\n')
    INTO _sql
    FROM pg_proc
    WHERE prokind = 'f' AND pronamespace = 'public'::regnamespace; -- Replace 'public' with your schema if needed

    IF _sql IS NOT NULL THEN
        EXECUTE _sql;
    END IF;
END
$do$;
