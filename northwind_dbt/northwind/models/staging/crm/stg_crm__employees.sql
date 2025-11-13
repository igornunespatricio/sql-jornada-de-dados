WITH employees AS (
    SELECT * FROM {{ source('northwind', 'employees') }}
)

SELECT
    -- Primary key
    employee_id,
    
    -- Personal information
    last_name,
    first_name,
    title,
    title_of_courtesy,
    
    -- Dates
    CAST(birth_date AS DATE) AS birth_date,
    CAST(hire_date AS DATE) AS hire_date,
    
    -- Address information
    address,
    city,
    COALESCE(region, 'Unknown') AS region,
    postal_code,
    country,
    
    -- Contact information
    home_phone,
    extension,
    
    -- Binary data (typically excluded or handled separately)
    -- photo,
    notes,
    
    -- Hierarchy
    reports_to,
    
    -- URL (typically excluded from analytics)
    -- photo_path,
    
    -- Derived fields
    first_name || ' ' || last_name AS full_name,
    CASE 
        WHEN title ILIKE '%manager%' OR title ILIKE '%vp%' OR title ILIKE '%president%' THEN 'Management'
        WHEN title ILIKE '%representative%' OR title ILIKE '%coordinator%' THEN 'Staff'
        ELSE 'Other'
    END AS employment_level,
    
    -- Date calculations
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) AS current_age,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date)) AS years_of_service,
    
    -- Data quality flags
    reports_to IS NULL AS is_top_level_manager_flag,
    region IS NULL AS has_missing_region_flag,
    home_phone IS NULL AS has_missing_phone_flag

FROM {{ source('northwind', 'employees') }}