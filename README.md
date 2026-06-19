# HBP Data Engineering Training Project
## Overview

This repository documents my 10-day hands-on data engineering training project. The goal is to design and build a modern data pipeline using industry-standard tools and best practices.

The project follows a full data lifecycle:

* Data ingestion
* Data storage
* Data transformation
* Data serving

It is structured to reflect a production-grade data engineering workflow using ELT principles.

---

## Project Structure

```
data/
  raw/            # Raw ingested data
  processed/      # Cleaned and transformed data

sql/
  schema/         # SQL scripts for table creation

models/
  staging/        # Staging models (clean + standardize)
  intermediate/   # Intermediate transformations
  marts/          # Business-level models
  schema/         # Model schema definitions

ingestion/        # Data ingestion scripts and configs
dbt_project/      # dbt configuration files
tests/            # Data quality tests
macros/           # Reusable dbt macros
```

---

## Pipeline Architecture

The diagram below represents the end-to-end HBP v2 data lifecycle, covering multi-channel data ingestion, raw storage schemas, layered dbt transformations, and dual serving options.

![HBP Pipeline v2 Architecture](data/raw/pipeline_v2.png)

This pipeline follows a modern ELT approach:

* **Data Ingestion & Raw Storage**: Data is ingested via two distinct paths:
  * Custom API/Batch pipelines using **Python** landing in the `HBP_RAW.INGEST` schema.
  * Automated third-party ingestion via **Fivetran** landing in the `HBP_RAW.FIVETRAN_SUPPLIER` schema.
* **Layered dbt Transformation**: Raw data is incrementally cleaned and modeled through four distinct dbt layers:
  * **Staging**: Light cleaning, type casting, and standardizing.
  * **Intermediate**: Ephemeral or materialized joins and basic business logic.
  * **Marts**: Dimension and fact tables optimized for performance.
  * **Operational/Reporting**: Aggregated tables structured for end-user tools.
* **Dual Serving Options**: Transformed data is served to two primary targets:
  * **BI Tools** (e.g., Metabase/Looker) for analytical reporting and decision-making.
  * **Operational Data Consumers** (via Reverse ETL or APIs) to power business workflows.


## 10-Day Build Plan

### Day 1–2: Foundations

* Set up project structure
* Understand data lifecycle (ELT vs ETL)


### Day 3–4: Ingestion

* Ingest data using APIs or batch pipelines
* Store raw data

### Day 5–6: Storage & SQL

* Design schemas
* Load data into warehouse 

### Day 7–8: Transformation (dbt)

* Build staging models
* Create intermediate and mart layers

### Day 9: Testing

* Add data quality checks
* Validate transformations

### Day 10: Serving & Documentation

* Connect BI tool 
* Finalize documentation and project showcase

---

## Key Concepts

* ELT pipelines
* Data modeling
* Data quality testing
* Analytics engineering

---

## Goal

To build a scalable, maintainable, and production-ready data pipeline that demonstrates real-world data engineering skills.


##Data Quality Issues
# 1. What Data Quality Issues I Identified

## Issue 2: Missing `resolved_at` Values/Non Validated

### Why It Matters

Open tickets have not yet been resolved, so there is no resolution date.

### How to Handle It

- Allow NULL values in `resolved_at`.
- Do not fail validation.
- Set `days_to_resolve` to NULL for unresolved tickets.
