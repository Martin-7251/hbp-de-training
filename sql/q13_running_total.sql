-- =====================================================
-- Running total of revenue (completed orders only)
-- =====================================================

USE DATABASE HBP_PRACTICE;
USE SCHEMA RAW;
USE WAREHOUSE PRACTICE_WH;

WITH base AS (

    SELECT
        order_id,
        TO_TIMESTAMP(ordered_at) AS ordered_at,
        CAST(quantity AS INTEGER) * CAST(unit_price_pence AS INTEGER) AS line_total_pence
    FROM ORDERS
    WHERE LOWER(status) = 'completed'

)

SELECT
    order_id,
    ordered_at,
    line_total_pence,
    SUM(line_total_pence) OVER (
        ORDER BY ordered_at
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_pence
FROM base;