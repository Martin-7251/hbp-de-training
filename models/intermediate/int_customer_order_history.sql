-- =====================================================
-- Customer Order History (int_customer_order_history)
-- One row per order with customer context + window metrics
-- =====================================================

WITH clean_customers AS (

    SELECT
        customer_id,
        first_name,
        last_name,
        email,
        country,
        created_at,
        is_active
    FROM {{ ref('stg_customers') }}

),

orders_joined AS (

    SELECT
        o.customer_id,
        o.order_id,
        c.first_name,
        c.last_name,
        c.email,
        c.country,
        o.ordered_at,
        o.quantity,
        o.unit_price_pence,
        o.line_total_pence

    FROM {{ ref('stg_orders') }} o
    INNER JOIN clean_customers c
        ON o.customer_id = c.customer_id

),

final AS (

    SELECT
        *,

        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY ordered_at
        ) AS order_rank,

        LAG(ordered_at) OVER (
            PARTITION BY customer_id
            ORDER BY ordered_at
        ) AS prev_order_date,

        -- PostgreSQL native date difference calculation
        (ordered_at::date - LAG(ordered_at) OVER (
            PARTITION BY customer_id
            ORDER BY ordered_at
        )::date) AS days_since_last_order,

        SUM(line_total_pence) OVER (
            PARTITION BY customer_id
            ORDER BY ordered_at
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_total_spend_pence

    FROM orders_joined

)

SELECT *
FROM final
