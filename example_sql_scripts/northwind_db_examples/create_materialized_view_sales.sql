CREATE MATERIALIZED VIEW IF NOT EXISTS mv_monthly_revenue AS
SELECT EXTRACT(
        YEAR
        FROM o.order_date
    ) AS YEAR,
    EXTRACT(
        MONTH
        FROM o.order_date
    ) AS MONTH,
    SUM(od.unit_price * od.quantity) AS total_revenue
FROM orders o
    INNER JOIN order_details od ON o.order_id = od.order_id
GROUP BY YEAR,
    MONTH
ORDER BY YEAR,
    MONTH