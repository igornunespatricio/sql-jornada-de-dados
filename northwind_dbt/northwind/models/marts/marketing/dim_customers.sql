-- marts/marketing/dim_customers.sql
WITH customer_orders AS (
    SELECT 
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        CAST(SUM(od.net_amount) AS DECIMAL(15,2)) AS total_spent,
        CAST(
            CASE 
                WHEN COUNT(DISTINCT o.order_id) > 0 
                THEN SUM(od.net_amount) / COUNT(DISTINCT o.order_id) 
                ELSE 0 
            END AS DECIMAL(15,2)
        ) AS avg_order_value
    FROM {{ ref('stg_crm__orders') }} o
    LEFT JOIN {{ ref('stg_crm__order_details') }} od ON o.order_id = od.order_id
    GROUP BY o.customer_id
)

SELECT
    cust.customer_id,
    cust.company_name,
    cust.contact_name,
    cust.contact_category,
    cust.country,
    cust.region,
    cust.city,
    
    -- Order patterns from CTE
    COALESCE(co.total_orders, 0) AS total_orders,
    COALESCE(co.total_spent, 0) AS total_spent,
    COALESCE(co.avg_order_value, 0) AS avg_order_value,
    
    -- Data quality
    cust.has_missing_phone_flag,
    cust.has_missing_region_flag

FROM {{ ref('stg_crm__customers') }} cust
LEFT JOIN customer_orders co ON cust.customer_id = co.customer_id