WITH products AS (
    SELECT * FROM {{ source('northwind', 'products') }}
)

SELECT
    -- Primary key
    product_id,
    
    -- Product information
    product_name,
    supplier_id,
    category_id,
    quantity_per_unit,
    
    -- Pricing and inventory
    CAST(unit_price AS DECIMAL(10,2)) AS unit_price,
    units_in_stock,
    units_on_order,
    reorder_level,
    
    -- Status
    discontinued,
    
    -- Derived calculations
    units_in_stock + units_on_order AS total_available_units,
    units_in_stock - reorder_level AS units_above_reorder_level,
    
    -- Inventory status
    CASE 
        WHEN units_in_stock = 0 THEN 'Out of Stock'
        WHEN units_in_stock <= reorder_level THEN 'Low Stock'
        ELSE 'In Stock'
    END AS inventory_status,
    
    -- Product status
    CASE 
        WHEN discontinued = 1 THEN 'Discontinued'
        ELSE 'Active'
    END AS product_status,
    
    -- Data quality flags
    unit_price <= 0 AS has_invalid_price_flag,
    units_in_stock < 0 AS has_negative_stock_flag,
    units_on_order < 0 AS has_negative_order_flag,
    reorder_level < 0 AS has_negative_reorder_flag

FROM products