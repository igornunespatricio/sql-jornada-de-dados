SELECT
    -- Primary key
    shipper_id,
    
    -- Company information
    company_name,
    phone,
    
    -- Data quality flags
    phone IS NULL AS has_missing_phone_flag

FROM {{ source('northwind', 'shippers') }}