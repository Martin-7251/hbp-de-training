-- =========================================================
-- File: 00_setup_production_environment.sql
-- Purpose: Create HBP warehouse, databases, and schemas
-- This script is idempotent and safe to run multiple times
-- Run ONCE before loading any data
-- Created: 2026-06-10
-- =========================================================

-- Warehouses
CREATE WAREHOUSE IF NOT EXISTS HBP_WH
WITH WAREHOUSE_SIZE = 'XSMALL'
AUTO_SUSPEND = 60
AUTO_RESUME = TRUE;

CREATE WAREHOUSE IF NOT EXISTS PRACTICE_WH
WITH WAREHOUSE_SIZE = 'XSMALL'
AUTO_SUSPEND = 60
AUTO_RESUME = TRUE;

-- Databases
CREATE DATABASE IF NOT EXISTS HBP_RAW;
CREATE DATABASE IF NOT EXISTS HBP_ANALYTICS;

-- Schemas (RAW)
CREATE SCHEMA IF NOT EXISTS HBP_RAW.INGEST;

-- Schemas (ANALYTICS)
CREATE SCHEMA IF NOT EXISTS HBP_ANALYTICS.STAGING;
CREATE SCHEMA IF NOT EXISTS HBP_ANALYTICS.INTERMEDIATE;
CREATE SCHEMA IF NOT EXISTS HBP_ANALYTICS.MARTS;