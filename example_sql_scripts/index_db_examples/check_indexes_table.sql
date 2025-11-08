SELECT tablename AS "Tabela",
    indexname AS "Índice",
    indexdef AS "Definição do Índice"
FROM pg_indexes
WHERE tablename = 'pessoas';