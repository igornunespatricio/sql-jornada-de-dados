WITH cte AS (
    SELECT
        id,
        col1 as first_name,
        col2 as last_name,
        date,
        new_col
    FROM
        {{ ref("raw_crm__new_table") }}
)
SELECT 
    *
FROM 
    cte