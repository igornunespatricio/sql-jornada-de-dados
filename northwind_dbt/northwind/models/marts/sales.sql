with sales as (
    select 
        *
    from 
        {{ ref('stg_crm__new_table') }}
)
select 
    *
from 
    sales
