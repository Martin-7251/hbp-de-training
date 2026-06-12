-- =====================================================
-- Window Functions Reference Library
-- Purpose: Quick patterns for daily use
-- =====================================================

-- 1. ROW_NUMBER: sequential ranking per group
SELECT
    customer_id,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY ordered_at) AS rn
FROM ORDERS;

-- 2. RANK vs DENSE_RANK: handling ties
SELECT
    customer_id,
    total_spend,
    RANK() OVER (ORDER BY total_spend DESC) AS rank_standard,
    DENSE_RANK() OVER (ORDER BY total_spend DESC) AS rank_dense
FROM customer_spend;

-- 3. LAG: previous row value
SELECT
    customer_id,
    ordered_at,
    LAG(ordered_at) OVER (PARTITION BY customer_id ORDER BY ordered_at) AS prev_order
FROM ORDERS;

-- 4. LEAD: next row value
SELECT
    customer_id,
    ordered_at,
    LEAD(ordered_at) OVER (PARTITION BY customer_id ORDER BY ordered_at) AS next_order
FROM ORDERS;

-- 5. Running total
SELECT
    ordered_at,
    SUM(line_total_pence) OVER (
        ORDER BY ordered_at
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM orders_clean;

-- 6. NTILE: bucket distribution
SELECT
    customer_id,
    NTILE(4) OVER (ORDER BY total_spend DESC) AS quartile
FROM customer_spend;

-- 7. FIRST_VALUE vs LAST_VALUE
-- FIRST_VALUE: returns first value in partition (stable)
-- LAST_VALUE: depends on frame (important!)

SELECT
    customer_id,
    ordered_at,

    FIRST_VALUE(ordered_at) OVER (
        PARTITION BY customer_id
        ORDER BY ordered_at
    ) AS first_order_date,

    LAST_VALUE(ordered_at) OVER (
        PARTITION BY customer_id
        ORDER BY ordered_at
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_order_date

FROM ORDERS;