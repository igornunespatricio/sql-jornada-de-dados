with int_aggregatte_by_category_id as (
    SELECT
        id,
        count(*)
    FROM 
        {{ ref("stg_crm__new_table") }}
    GROUP BY 
        id
)

select * from int_aggregatte_by_category_id