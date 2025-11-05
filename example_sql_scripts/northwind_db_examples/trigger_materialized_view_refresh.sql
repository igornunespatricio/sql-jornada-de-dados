SELECT *
FROM mv_monthly_revenue
ORDER BY YEAR DESC,
    MONTH DESC;

UPDATE orders
SET order_date = '1999-05-01'
WHERE order_id IN (
        SELECT order_id
        FROM orders
        ORDER BY order_date DESC
        LIMIT 10
    );