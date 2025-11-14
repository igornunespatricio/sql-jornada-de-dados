-- marts/finance/fct_sales.sql
SELECT 
    -- Keys
    od.order_id,
    od.product_id,
    o.customer_id,
    o.employee_id,
    o.shipper_id,
    o.order_date,
    p.category_id,
    
    -- Sales metrics
    od.gross_amount,
    od.net_amount,
    od.discount_amount,
    od.quantity,
    o.freight,
    
    -- Product context
    p.product_name,
    p.product_status,
    c.category_name,
    
    -- Customer context
    cust.company_name,
    cust.contact_name,
    cust.country,
    
    -- Employee context
    emp.full_name AS employee_name,
    emp.employment_level,
    
    -- Shipper context
    s.company_name AS shipper_company_name,
    s.phone AS shipper_phone,
    
    -- Derived fields for analysis with proper decimal casting
    CAST(
        CASE 
            WHEN od.gross_amount > 0 THEN od.discount_amount / od.gross_amount 
            ELSE 0 
        END AS DECIMAL(5,4)
    ) AS discount_rate,
    
    CAST(
        CASE 
            WHEN od.net_amount > 0 THEN o.freight / od.net_amount 
            ELSE 0 
        END AS DECIMAL(10,6)
    ) AS freight_to_sales_ratio,
    
    -- Data quality flags
    od.net_amount < 0 AS has_negative_sales_flag,
    (od.discount_amount / NULLIF(od.gross_amount, 0)) > 0.5 AS has_excessive_discount_flag,
    s.has_missing_phone_flag AS has_missing_shipper_phone_flag

FROM {{ ref('stg_crm__order_details') }} od
LEFT JOIN {{ ref('stg_crm__orders') }} o ON od.order_id = o.order_id
LEFT JOIN {{ ref('stg_crm__products') }} p ON od.product_id = p.product_id
LEFT JOIN {{ ref('stg_crm__customers') }} cust ON o.customer_id = cust.customer_id
LEFT JOIN {{ ref('stg_crm__employees') }} emp ON o.employee_id = emp.employee_id
LEFT JOIN {{ ref('stg_crm__categories') }} c ON p.category_id = c.category_id
LEFT JOIN {{ ref('stg_crm__shippers') }} s ON o.shipper_id = s.shipper_id