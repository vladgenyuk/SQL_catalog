SELECT
    routine_name
FROM
    information_schema.routines
WHERE
    specific_schema = 'public'
    AND routine_type = 'FUNCTION';
