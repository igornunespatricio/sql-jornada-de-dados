DROP VIEW IF EXISTS revenue_per_customer;


CREATE VIEW revenue_per_customer AS
SELECT
    customers.company_name,
    SUM(
        order_details.unit_price * order_details.quantity * (1.0 - order_details.discount)
    ) AS total_revenue
FROM
    customers
    INNER JOIN orders ON customers.customer_id = orders.customer_id
    INNER JOIN order_details ON order_details.order_id = orders.order_id
GROUP BY
    customers.company_name
ORDER BY
    total_revenue DESC;