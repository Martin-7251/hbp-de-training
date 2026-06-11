-- =====================================================
-- LEFT JOIN: last order per customer
-- =====================================================

USE DATABASE HBP_PRACTICE;
USE SCHEMA RAW;
USE WAREHOUSE PRACTICE_WH;

SELECT
    c.customer_id,
    MAX(TO_TIMESTAMP(o.ordered_at)) AS last_order_date
FROM CUSTOMERS AS c
LEFT JOIN ORDERS AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id;