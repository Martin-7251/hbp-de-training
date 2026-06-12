-- =====================================================
-- ROW_NUMBER comparison:
-- Window function vs correlated subquery
-- =====================================================

USE DATABASE HBP_PRACTICE;
USE SCHEMA RAW;
USE WAREHOUSE PRACTICE_WH;

-- =========================
-- Version 1: Window function
-- =========================
SELECT
    customer_id,
    order_id,
    TO_TIMESTAMP(ordered_at) AS ordered_at,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY TO_TIMESTAMP(ordered_at)
    ) AS row_num
FROM ORDERS
ORDER BY customer_id DESC;;


-- =========================
-- Version 2: Correlated subquery
-- =========================
SELECT
    o1.customer_id,
    o1.order_id,
    TO_TIMESTAMP(o1.ordered_at) AS ordered_at,
    (
        SELECT COUNT(*)
        FROM ORDERS o2
        WHERE o2.customer_id = o1.customer_id
          AND TO_TIMESTAMP(o2.ordered_at) <= TO_TIMESTAMP(o1.ordered_at)
    ) AS row_num
FROM ORDERS o1
ORDER BY customer_id DESC;