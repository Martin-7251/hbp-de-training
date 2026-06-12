-- =====================================================
-- NTILE(4): divide customers into spend quartiles
-- Note: With 8 customers, each quartile will have ~2 customers
-- =====================================================

USE DATABASE HBP_PRACTICE;
USE SCHEMA RAW;
USE WAREHOUSE PRACTICE_WH;

WITH customer_spend AS (

    SELECT
        customer_id,
        SUM(
            CAST(quantity AS INTEGER) * CAST(unit_price_pence AS INTEGER)
        ) AS total_spend
    FROM ORDERS
    WHERE LOWER(status) = 'completed'
    GROUP BY customer_id

)

SELECT
    customer_id,
    total_spend,
    NTILE(4) OVER (
        ORDER BY total_spend DESC
    ) AS spend_quartile
FROM customer_spend;