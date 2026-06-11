-- =====================================================
-- CTE vs Subquery comparison
-- =====================================================

USE DATABASE HBP_PRACTICE;
USE SCHEMA RAW;
USE WAREHOUSE PRACTICE_WH;

-- =========================
-- CTE version
-- =========================
WITH customer_spend AS (

    SELECT
        customer_id,
        SUM(CAST(quantity AS INTEGER) * CAST(unit_price_pence AS INTEGER)) AS total_spend
    FROM ORDERS
    WHERE LOWER(status) = 'completed'
    GROUP BY customer_id

)

SELECT
    customer_id,
    total_spend
FROM customer_spend
WHERE total_spend > 10000;

-- =========================
-- Subquery version
-- =========================

SELECT
    customer_id,
    total_spend
FROM (

    SELECT
        customer_id,
        SUM(CAST(quantity AS INTEGER) * CAST(unit_price_pence AS INTEGER)) AS total_spend
    FROM ORDERS
    WHERE LOWER(status) = 'completed'
    GROUP BY customer_id

) AS sub
WHERE total_spend > 10000;