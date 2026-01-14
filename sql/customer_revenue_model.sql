-- Create an analytics-ready customer revenue model

WITH base_orders AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_date,
        o.order_amount,
        c.customer_name,
        c.signup_date
    FROM raw.orders o
    JOIN raw.customers c
        ON o.customer_id = c.customer_id
),

customer_metrics AS (
    SELECT
        customer_id,
        customer_name,
        MIN(order_date) AS first_order_date,
        COUNT(order_id) AS total_orders,
        SUM(order_amount) AS lifetime_revenue
    FROM base_orders
    GROUP BY customer_id, customer_name
)

SELECT
    customer_id,
    customer_name,
    first_order_date,
    total_orders,
    lifetime_revenue,
    lifetime_revenue / NULLIF(total_orders, 0) AS avg_order_value
FROM customer_metrics;
