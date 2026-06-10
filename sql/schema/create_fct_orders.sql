-- =================================================
-- Table: HBP_ANALYTICS.FCT_ORDERS
-- Purpose: Fact table for order transactions
-- Grain: One row per order line item
-- Created: 2026-06-10
-- =================================================

USE DATABASE HBP_ANALYTICS;
USE SCHEMA MARTS;

CREATE TABLE IF NOT EXISTS FCT_ORDERS (
    order_id          INTEGER       NOT NULL,
    customer_id       INTEGER,
    product_id        VARCHAR(20),
    date_id           DATE,

    quantity          INTEGER,
    unit_price_pence  INTEGER,
    line_total_pence  INTEGER,

    status            VARCHAR(20),

    PRIMARY KEY (order_id),

    FOREIGN KEY (customer_id)
        REFERENCES HBP_ANALYTICS.STAGING.DIM_CUSTOMERS(customer_id),

    FOREIGN KEY (product_id)
        REFERENCES HBP_ANALYTICS.STAGING.DIM_PRODUCTS(product_id),

    FOREIGN KEY (date_id)
        REFERENCES HBP_ANALYTICS.STAGING.DIM_DATE(date_id)
);
