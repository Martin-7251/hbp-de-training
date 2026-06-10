-- =================================================
-- Table: HBP_RAW.INGEST.DIM_CUSTOMERS
-- Purpose: Raw customer dimension landed from CSV ingestion
-- Columns stored as VARCHAR to preserve raw format
-- Cleaning happens in dbt staging layer
-- Created: 2026-06-10
-- =================================================

USE DATABASE HBP_RAW;
USE SCHEMA INGEST;

CREATE TABLE IF NOT EXISTS DIM_CUSTOMERS (
    customer_id   VARCHAR(50)  NOT NULL COMMENT 'Unique customer identifier',
    first_name    VARCHAR(100) COMMENT 'Customer first name',
    last_name     VARCHAR(100) COMMENT 'Customer last name',
    email         VARCHAR(255) COMMENT 'Email address (mixed case raw)',
    country       VARCHAR(10)  COMMENT 'Two-letter country code (lowercase raw)',
    created_at    TIMESTAMP  COMMENT 'Creation date as string',
    is_active     BOOLEAN  COMMENT 'true/false stored as text',
    CONSTRAINT pk_customers PRIMARY KEY (customer_id)
);
