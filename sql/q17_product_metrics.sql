-- =====================================================
-- Product Metrics (int_product_metrics)
-- One row per product with aggregated performance
-- =====================================================

USE DATABASE HBP_PRACTICE;
USE SCHEMA RAW;
USE WAREHOUSE PRACTICE_WH;

WITH base AS (

    SELECT
        p.product_id,
        p.product_name,
        o.order_id,
        CAST(o.quantity AS INTEGER) AS quantity,
        CAST(o.unit_price_pence AS INTEGER) AS unit_price_pence,
        LOWER(o.status) AS status
    FROM PRODUCTS AS p
    LEFT JOIN ORDERS AS o
        ON p.product_name = o.product_name

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
                THEN quantity * unit_price_pence
                ELSE 0
            END
        ) AS total_revenue_pence

    FROM base
    GROUP BY
        product_id,
        product_name

)

SELECT
    product_id,
    product_name,
    total_orders,
    total_quantity_sold,
    total_revenue_pence,

    CASE
        WHEN total_orders > 0
        THEN total_quantity_sold / total_orders
        ELSE 0
    END AS avg_quantity_per_order,

    DENSE_RANK() OVER (
        ORDER BY total_revenue_pence DESC
    ) AS rank_by_revenue

FROM aggregated;