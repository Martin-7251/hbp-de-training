-- =====================================================
-- RANK vs DENSE_RANK: customers by total spend
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
    RANK() OVER (ORDER BY total_spend DESC) AS rank_standard,
    DENSE_RANK() OVER (ORDER BY total_spend DESC) AS rank_dense
FROM customer_spend;