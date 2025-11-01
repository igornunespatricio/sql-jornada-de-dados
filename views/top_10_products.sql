DROP VIEW IF EXISTS top_10_products;


CREATE VIEW top_10_products AS
SELECT
    products.product_name,
    SUM(
        order_details.unit_price * order_details.quantity * (1.0 - order_details.discount)
    ) AS total_amount
FROM
    products
    INNER JOIN order_details ON order_details.product_id = products.product_id
GROUP BY
    products.product_name
ORDER BY
    total_amount DESC
LIMIT
    10;