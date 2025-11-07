EXPLAIN ANALYZE
SELECT id,
    first_name,
    middle_name
FROM pessoas
WHERE id = 100
    OR first_name = 'aa';