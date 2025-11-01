CREATE
OR REPLACE VIEW monthly_revenue AS WITH MonthlyRevenue AS (
    SELECT
        EXTRACT(
            YEAR
            FROM
                orders.order_date
        ) AS year,
        EXTRACT(
            MONTH
            FROM
                orders.order_date
        ) AS MONTH,
        SUM(
            order_details.unit_price * order_details.quantity * (1.0 - order_details.discount)
        ) AS monthly_revenue
    FROM
        orders
        INNER JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY
        EXTRACT(
            YEAR
            FROM
                orders.order_date
        ),
        EXTRACT(
            MONTH
            FROM
                orders.order_date
        )
),
CumulativeRevenue AS (
    SELECT
        year,
        MONTH,
        monthly_revenue,
        SUM(monthly_revenue) OVER (
            PARTITION BY year
            ORDER BY
                MONTH
        ) AS ytd_revenue
    FROM
        MonthlyRevenue
)
SELECT
    year,
    MONTH,
    monthly_revenue,
    monthly_revenue - LAG(monthly_revenue) OVER (
        PARTITION BY year
        ORDER BY
            MONTH
    ) AS monthly_difference,
    ytd_revenue,
    (
        monthly_revenue - LAG(monthly_revenue) OVER (
            PARTITION BY year
            ORDER BY
                MONTH
        )
    ) / LAG(monthly_revenue) OVER (
        PARTITION BY year
        ORDER BY
            MONTH
    ) * 100 AS monthly_change_percentage
FROM
    CumulativeRevenue
ORDER BY
    year,
    MONTH;