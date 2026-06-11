-- =====================================================
-- INNER JOIN: Active customers with orders
-- =====================================================

USE DATABASE HBP_PRACTICE;
USE SCHEMA RAW;
USE WAREHOUSE PRACTICE_WH;

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.product_name,
    o.status
FROM CUSTOMERS AS c
INNER JOIN ORDERS AS o
    ON c.customer_id = o.customer_id
WHERE LOWER(c.is_active) = 'true';