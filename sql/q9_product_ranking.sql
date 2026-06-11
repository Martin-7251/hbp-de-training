-- =====================================================
-- Product revenue ranking (window function)
-- =====================================================

USE DATABASE HBP_PRACTICE;
USE SCHEMA RAW;
USE WAREHOUSE PRACTICE_WH;

WITH product_revenue AS (

    SELECT
        product_name,
        SUM(CAST(quantity AS INTEGER) * CAST(unit_price_pence AS INTEGER)) AS total_revenue_pence
    FROM ORDERS
    WHERE LOWER(status) = 'completed'
    GROUP BY product_name

)

SELECT
    product_name,
    total_revenue_pence,
    ROW_NUMBER() OVER (
        ORDER BY total_revenue_pence DESC
    ) AS revenue_rank
FROM product_revenue;