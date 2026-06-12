-- =====================================================
-- ROW_NUMBER: rank orders per customer (oldest → newest)
-- =====================================================

USE DATABASE HBP_PRACTICE;
USE SCHEMA RAW;
USE WAREHOUSE PRACTICE_WH;

SELECT
    customer_id,
    order_id,
    TO_TIMESTAMP(ordered_at) AS ordered_at,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY TO_TIMESTAMP(ordered_at) ASC
    ) AS order_rank
FROM ORDERS;