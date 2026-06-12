-- =====================================================
-- LEAD: next order details per customer
-- =====================================================

USE DATABASE HBP_PRACTICE;
USE SCHEMA RAW;
USE WAREHOUSE PRACTICE_WH;

WITH ordered_events AS (

    SELECT
        customer_id,
        order_id,
        product_name,
        TO_TIMESTAMP(ordered_at) AS ordered_at
    FROM ORDERS

)

SELECT
    customer_id,
    order_id,
    product_name,
    ordered_at,
    LEAD(product_name) OVER (
        PARTITION BY customer_id
        ORDER BY ordered_at
    ) AS next_product,
    LEAD(ordered_at) OVER (
        PARTITION BY customer_id
        ORDER BY ordered_at
    ) AS next_order_date
FROM ordered_events;