-- =====================================================
-- Products with high order quantities
-- =====================================================

USE DATABASE HBP_PRACTICE;
USE SCHEMA RAW;
USE WAREHOUSE PRACTICE_WH;

SELECT
    product_name,
    SUM(CAST(quantity AS INTEGER)) AS total_quantity
FROM ORDERS
WHERE LOWER(status) IN ('completed', 'pending')
GROUP BY
    product_name
HAVING
    SUM(CAST(quantity AS INTEGER)) > 2;