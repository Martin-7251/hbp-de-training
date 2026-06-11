-- =================================================
-- Table: HBP_ANALYTICS.DIM_DATE
-- Purpose: Date dimension for analytics and reporting
-- Grain: One row per calendar date
-- Created: 2026-06-10
-- =================================================

USE DATABASE HBP_ANALYTICS;
USE SCHEMA STAGING;

CREATE TABLE IF NOT EXISTS DIM_DATE (
    date_id       DATE PRIMARY KEY,
    full_date     DATE,
    year          INTEGER,
    month         INTEGER,
    month_name    VARCHAR(20),
    day           INTEGER,
    quarter       INTEGER,
    day_of_week   VARCHAR(20),
    is_weekend    BOOLEAN
);