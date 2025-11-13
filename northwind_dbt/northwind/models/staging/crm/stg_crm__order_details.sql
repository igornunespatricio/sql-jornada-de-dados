WITH cte AS (
    SELECT * FROM {{ source('northwind', 'order_details') }}
)

SELECT
    -- Primary key (composite of order_id + product_id)
    order_id,
    product_id,
    
    -- Pricing and quantity information
    unit_price,
    quantity,
    discount,
    
    -- Derived calculations
    unit_price * quantity AS gross_amount,
    unit_price * quantity * (1 - discount) AS net_amount,
    unit_price * quantity * discount AS discount_amount,
    
    -- Data quality flags
    discount < 0 OR discount > 1 AS has_invalid_discount_flag,
    quantity <= 0 AS has_invalid_quantity_flag,
    unit_price < 0 AS has_negative_price_flag

FROM cte