-- =================================================
-- Table: HBP_RAW.INGEST.DIM_PRODUCTS
-- Purpose: Raw product data from CSV ingestion
-- Created: 2026-06-10
-- =================================================

USE DATABASE HBP_RAW;
USE SCHEMA INGEST;

CREATE TABLE IF NOT EXISTS DIM_PRODUCTS (
    product_id        VARCHAR(20)  NOT NULL COMMENT 'Product ID (P001 format)',
    product_name      VARCHAR(255) COMMENT 'Product name',
    category          VARCHAR(100) COMMENT 'Product category',
    unit_price_pence  VARCHAR(20)  COMMENT 'Price stored as text',
    in_stock          VARCHAR(10)  COMMENT 'true/false stored as text',
    PRIMARY KEY (product_id)
);