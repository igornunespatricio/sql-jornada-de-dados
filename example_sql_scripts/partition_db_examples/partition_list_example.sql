explain analyze
SELECT *
FROM pessoas
WHERE estado = 'RJ';

explain analyze
SELECT *
FROM pessoas_partition_list
WHERE estado = 'RJ'