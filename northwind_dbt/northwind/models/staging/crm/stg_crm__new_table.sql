WITH cte AS (
    SELECT
        id,
        trim(col1) as first_name,
        trim(col2) as last_name,
        trim(col1) || ' ' || trim(col2) as full_name,
        date
    FROM
        {{ source("northwind", "new_table_seed") }}
)
SELECT 
    *
FROM 
    cte