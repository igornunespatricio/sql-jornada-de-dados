WITH customers AS (
    SELECT * FROM {{ source('northwind', 'customers') }}
)
SELECT
    -- Primary key
    customer_id,
    
    -- Company information
    company_name,
    contact_name,
    contact_title,
    
    -- Address information
    address,
    city,
    COALESCE(region, 'Unknown') AS region,
    postal_code,
    country,
    
    -- Contact information
    phone,
    fax,
    
    -- Derived fields
    CASE 
        WHEN contact_title ILIKE '%owner%' THEN 'Owner'
        WHEN contact_title ILIKE '%manager%' THEN 'Manager'
        WHEN contact_title ILIKE '%representative%' THEN 'Representative'
        WHEN contact_title ILIKE '%agent%' THEN 'Agent'
        ELSE 'Other'
    END AS contact_category,
    
    -- Data quality flags
    phone IS NULL AS has_missing_phone_flag,
    region IS NULL AS has_missing_region_flag

FROM customers