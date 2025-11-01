CREATE
OR REPLACE VIEW total_revenue_per_year AS
SELECT
    EXTRACT(
        YEAR
        FROM
            o.order_date
    ) AS year,
    SUM(od.unit_price * od.quantity) AS total_revenue
FROM
    order_details AS od
    INNER JOIN orders AS o ON od.order_id = o.order_id
GROUP BY
    year
ORDER BY
    year;