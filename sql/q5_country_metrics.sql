-- =====================================================
-- Country-level customer and revenue metrics
-- =====================================================

USE DATABASE HBP_PRACTICE;
USE SCHEMA RAW;
USE WAREHOUSE PRACTICE_WH;

SELECT
    UPPER(c.country) AS country,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT CASE
        WHEN LOWER(c.is_active) = 'true'
        THEN c.customer_id
    END) AS active_customers,
    COUNT(o.order_id) AS total_orders,
    SUM(
        CASE
            WHEN LOWER(o.status) = 'completed'
            THEN CAST(o.quantity AS INTEGER) * CAST(o.unit_price_pence AS INTEGER)
            ELSE 0
        END
    ) AS revenue_completed
FROM CUSTOMERS AS c
LEFT JOIN ORDERS AS o
    ON c.customer_id = o.customer_id
GROUP BY
    UPPER(c.country);