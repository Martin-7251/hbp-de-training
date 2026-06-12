-- =====================================================
-- LAG: days since previous order per customer
-- =====================================================

USE DATABASE HBP_PRACTICE;
USE SCHEMA RAW;
USE WAREHOUSE PRACTICE_WH;

WITH ordered_events AS (

    SELECT
        customer_id,
        order_id,
        TO_TIMESTAMP(ordered_at) AS ordered_at
    FROM ORDERS

)

SELECT
    customer_id,
    order_id,
    ordered_at,
    DATEDIFF(
        day,
        LAG(ordered_at) OVER (
            PARTITION BY customer_id
            ORDER BY ordered_at
        ),
        ordered_at
    ) AS days_since_previous_order
FROM ordered_events;