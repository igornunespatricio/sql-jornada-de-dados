WITH cte AS (
    SELECT * FROM {{ source('northwind', 'orders') }}
)

SELECT
    -- Primary key with consistent naming
    order_id,
    
    -- Foreign keys with consistent naming
    customer_id,
    employee_id,
    
    -- Date fields with proper casting and validation
    CAST(order_date AS DATE) AS order_date,
    CAST(required_date AS DATE) AS required_date,
    CAST(shipped_date AS DATE) AS shipped_date,
    
    -- Shipping information
    ship_via AS shipper_id,
    freight,
    ship_name,
    ship_address,
    ship_city,
    ship_region,
    ship_postal_code,
    ship_country,
    
    -- Derived fields
    CASE 
        WHEN shipped_date IS NOT NULL THEN 'shipped'
        WHEN shipped_date IS NULL AND CURRENT_DATE > required_date THEN 'overdue'
        ELSE 'processing'
    END AS order_status,
    
    -- Date calculations
    shipped_date - order_date AS days_to_ship,
    
    -- Data quality checks
    freight < 0 AS has_negative_freight_flag,
    order_date > shipped_date AS has_invalid_dates_flag,
    shipped_date > required_date AS is_late_shipment_flag

FROM cte