-- =====================================================
-- Product Metrics (int_product_metrics)
-- One row per product with aggregated performance
-- =====================================================

WITH base AS (

    SELECT
        p.product_id,
        p.product_name,
        o.order_id,
        o.quantity,
        o.unit_price_pence,
        o.line_total_pence, -- Kept the missing column fix
        o.status

    FROM {{ ref('stg_products') }} p
    LEFT JOIN {{ ref('stg_orders') }} o
        ON p.product_name = o.product_name -- Reverted to product_name matching

),

aggregated AS (

    SELECT
        product_id,
        product_name,

        COUNT(DISTINCT order_id) AS total_orders,

        SUM(
            CASE
                WHEN status IN ('completed', 'pending')
                THEN quantity
                ELSE 0
            END
        ) AS total_quantity_sold,

        SUM(
            CASE
                WHEN status = 'completed'
                THEN line_total_pence
                ELSE 0
            END
        ) AS total_revenue_pence

    FROM base
    GROUP BY
        product_id,
        product_name

),

final AS (

    SELECT
        product_id,
        product_name,
        total_orders,
        total_quantity_sold,
        total_revenue_pence,

        CASE
            WHEN total_orders > 0
            -- Cast to numeric to prevent integer truncation during division
            THEN total_quantity_sold::numeric / total_orders
            ELSE 0
        END AS avg_quantity_per_order,

        DENSE_RANK() OVER (
            ORDER BY total_revenue_pence DESC
        ) AS rank_by_revenue

    FROM aggregated

)

SELECT * FROM final
