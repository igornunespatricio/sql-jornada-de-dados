{{
    config(
        materialized='incremental',
        unique_key='id',
        on_schema_change='fail'
    )
}}

with sales as (
    select 
        id,
        first_name,
        last_name,
        date
    from 
        {{ ref('stg_crm__new_table') }}
)
select 
    *
from 
    sales

{% if is_incremental() %}
    where date > (select max(date) from {{ this }})
{% endif %}