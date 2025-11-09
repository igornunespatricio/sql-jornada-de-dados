WITH cte AS (
    SELECT
        category_id as id,
        category_name as name
    FROM
        {{ ref("raw_crm__new_table") }}
)
SELECT 
    *
FROM 
    cte