SELECT 
    *
FROM {{ source('Northwind', 'categories') }}