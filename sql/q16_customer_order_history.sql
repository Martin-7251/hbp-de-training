-- =====================================================
-- Customer Order History (int_customer_order_history)
-- One row per order with customer context + window metrics
-- =====================================================

USE DATABASE HBP_PRACTICE;
USE SCHEMA RAW;
USE WAREHOUSE PRACTICE_WH;

WITH clean_customers AS (

    SELECT
        customer_id,
        TRIM(first_name) AS first_name,
        TRIM(last_name) AS last_name,
        LOWER(email) AS email,
        UPPER(country) AS country,
        TO_DATE(created_at) AS created_at,
        LOWER(is_active) = 'true' AS is_active
    FROM CUSTOMERS

),

orders_joined AS (

    SELECT
        o.customer_id,
        o.order_id,
        c.first_name,
        c.last_name,
        c.email,
        c.country,
        TO_TIMESTAMP(o.ordered_at) AS ordered_at,
        CAST(o.quantity AS INTEGER) AS quantity,
        CAST(o.unit_price_pence AS INTEGER) AS unit_price_pence,
        CAST(o.quantity AS INTEGER) * CAST(o.unit_price_pence AS INTEGER) AS line_total_pence
    FROM ORDERS AS o
    INNER JOIN clean_customers AS c
        ON o.customer_id = c.customer_id

),

final AS (

    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY ordered_at
        ) AS order_rank,

        LAG(ordered_at) OVER (
            PARTITION BY customer_id
            ORDER BY ordered_at
        ) AS prev_order_date,

        DATEDIFF(
            day,
            LAG(ordered_at) OVER (
                PARTITION BY customer_id
                ORDER BY ordered_at
            ),
            ordered_at
        ) AS days_since_last_order,

        SUM(line_total_pence) OVER (
            PARTITION BY customer_id
            ORDER BY ordered_at
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_total_spend_pence

    FROM orders_joined

)

SELECT *
FROM final;