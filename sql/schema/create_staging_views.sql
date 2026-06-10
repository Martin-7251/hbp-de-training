-- =================================================
-- File: 05_create_staging_views.sql
-- Purpose: Placeholder staging views (to be replaced by dbt models on Day 7)
-- Created: 2026-06-10
-- =================================================

USE DATABASE HBP_ANALYTICS;
USE SCHEMA STAGING;

CREATE OR REPLACE VIEW STG_CUSTOMERS AS SELECT * FROM HBP_RAW.INGEST.DIM_CUSTOMERS WHERE 1=0;
CREATE OR REPLACE VIEW STG_PRODUCTS  AS SELECT * FROM HBP_RAW.INGEST.DIM_PRODUCTS WHERE 1=0;
CREATE OR REPLACE VIEW STG_ORDERS    AS SELECT * FROM HBP_RAW.INGEST.ORDERS WHERE 1=0;