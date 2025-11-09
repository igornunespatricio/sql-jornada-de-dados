WITH cte AS (
    SELECT category_id AS id,
        category_name AS description
    FROM {{ source('Northwind', 'categories') }}
)
SELECT *
FROM cte