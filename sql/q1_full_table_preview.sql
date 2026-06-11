-- =====================================================
-- File: q1_full_table_preview.sql
-- Purpose: Preview raw tables for validation
-- =====================================================

USE DATABASE HBP_PRACTICE;
USE SCHEMA RAW;
USE WAREHOUSE PRACTICE_WH;

SELECT
    customer_id,
    first_name,
    last_name,
    email,
    country,
    created_at,
    is_active
FROM CUSTOMERS;

SELECT
    order_id,
    customer_id,
    product_name,
    quantity,
    unit_price_pence,
    status,
    ordered_at
FROM ORDERS;

SELECT
    product_id,
    product_name,
    category,
    unit_price_pence,
    in_stock
FROM PRODUCTS;