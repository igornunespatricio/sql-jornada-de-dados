SELECT pg_size_pretty(pg_relation_size('idx_first_name'));

SELECT pg_size_pretty(pg_column_size(first_name)::bigint) AS tamanho_total
FROM pessoas;

SELECT pg_size_pretty(SUM(pg_column_size(first_name)::bigint)) AS tamanho_total
FROM pessoas;