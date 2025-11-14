SELECT
    -- Primary key
    category_id,
    
    -- Category information
    category_name,
    description,
    
    -- Binary data (typically excluded from analytics)
    -- picture,
    
    -- Derived fields for better analysis
    CASE 
        WHEN category_name IN ('Beverages', 'Dairy Products', 'Produce') THEN 'Perishable'
        WHEN category_name IN ('Meat/Poultry', 'Seafood') THEN 'Highly Perishable'
        ELSE 'Shelf Stable'
    END AS perishability_category,
    
    -- Data quality flags
    description IS NULL AS has_missing_description_flag

FROM {{ source('northwind', 'categories') }}