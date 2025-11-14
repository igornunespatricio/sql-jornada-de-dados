-- marts/hr/fct_employee_performance.sql
SELECT
    emp.employee_id,
    emp.full_name,
    emp.employment_level,
    emp.years_of_service,
    emp.region,
    
    -- Sales performance metrics
    COUNT(DISTINCT o.order_id) AS orders_handled,
    CAST(SUM(od.net_amount) AS DECIMAL(15,2)) AS total_sales,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    CAST(AVG(o.days_to_ship) AS DECIMAL(10,4)) AS avg_days_to_ship,
    
    -- Derived performance metrics - CAST the FINAL result, not intermediate calculations
    CAST(
        CASE 
            WHEN COUNT(DISTINCT o.order_id) > 0 
            THEN SUM(od.net_amount) / COUNT(DISTINCT o.order_id)
            ELSE 0 
        END AS DECIMAL(15,2)
    ) AS avg_sale_per_order,
    
    CAST(
        CASE 
            WHEN emp.years_of_service > 0 
            THEN SUM(od.net_amount) / emp.years_of_service
            ELSE 0 
        END AS DECIMAL(15,2)
    ) AS sales_per_year_of_service,
    
    CAST(
        CASE 
            WHEN COUNT(DISTINCT o.order_id) > 0 
            THEN COUNT(DISTINCT o.customer_id)::DECIMAL / COUNT(DISTINCT o.order_id)
            ELSE 0 
        END AS DECIMAL(10,4)
    ) AS customers_per_order

FROM {{ ref('stg_crm__employees') }} emp
LEFT JOIN {{ ref('stg_crm__orders') }} o ON emp.employee_id = o.employee_id
LEFT JOIN {{ ref('stg_crm__order_details') }} od ON o.order_id = od.order_id
GROUP BY 
    emp.employee_id,
    emp.full_name,
    emp.employment_level,
    emp.years_of_service,
    emp.region