-- =====================================================
-- Customer Summary Mart (mart_customer_summary)
-- Gold Layer: Combined customer profile and aggregated order metrics
-- =====================================================

WITH customer_profile AS (

    SELECT
        customer_id,
        first_name,
        last_name,
        email,
        country,
        created_at AS customer_created_at,
        is_active
    FROM {{ ref('stg_customers') }}

),

customer_order_metrics AS (

    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders_placed,
        MAX(ordered_at) AS last_order_date,
        COALESCE(MAX(running_total_spend_pence), 0) AS lifetime_spend_pence

    FROM {{ ref('int_customer_order_history') }}
    GROUP BY customer_id

),

final AS (

    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.country,
        c.customer_created_at,
        c.is_active,
        
        -- Left joined order aggregations
        COALESCE(o.total_orders_placed, 0) AS total_orders_placed,
        o.last_order_date,
        COALESCE(o.lifetime_spend_pence, 0) AS lifetime_spend_pence,

        -- System metadata tracking row creation timestamp (PostgreSQL compatible)
        CURRENT_TIMESTAMP AS dbt_updated_at

    FROM customer_profile c
    LEFT JOIN customer_order_metrics o
        ON c.customer_id = o.customer_id

)

SELECT * FROM final
