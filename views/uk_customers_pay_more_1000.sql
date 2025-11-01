DROP VIEW IF EXISTS uk_customers_pay_more_1000;


CREATE VIEW uk_customers_pay_more_1000 AS
SELECT
    customers.contact_name,
    SUM(
        order_details.unit_price * order_details.quantity * (1.0 - order_details.discount)
    ) AS payments
FROM
    customers
    INNER JOIN orders ON orders.customer_id = customers.customer_id
    INNER JOIN order_details ON order_details.order_id = orders.order_id
WHERE
    LOWER(customers.country) = 'uk'
GROUP BY
    customers.contact_name
HAVING
    SUM(
        order_details.unit_price * order_details.quantity * (1.0 - order_details.discount)
    ) > 1000
ORDER BY
    payments DESC;