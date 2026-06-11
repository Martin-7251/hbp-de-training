-- =====================================================
-- Customer summary with order counts
-- =====================================================

USE DATABASE HBP_PRACTICE;
USE SCHEMA RAW;
USE WAREHOUSE PRACTICE_WH;

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    UPPER(c.country) AS country,
    COALESCE(COUNT(o.order_id), 0) AS order_count
FROM CUSTOMERS AS c
LEFT JOIN ORDERS AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    full_name,
    country;