-- marts/operations/dim_inventory.sql
SELECT
    p.product_id,
    p.product_name,
    p.product_status,
    p.inventory_status,
    
    -- Inventory metrics
    p.units_in_stock,
    p.units_on_order,
    p.reorder_level,
    p.total_available_units,
    p.units_above_reorder_level,
    
    -- Category context
    c.category_name,
    c.perishability_category,
    
    -- Pricing with proper casting
    CAST(p.unit_price AS DECIMAL(10,2)) AS unit_price,
    p.quantity_per_unit

FROM {{ ref('stg_crm__products') }} p
LEFT JOIN {{ ref('stg_crm__categories') }} c ON p.category_id = c.category_id