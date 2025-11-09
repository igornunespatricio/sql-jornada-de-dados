SELECT 
    *
FROM {{ source('Northwind', 'new_table_seed') }}