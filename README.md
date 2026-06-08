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

The diagram below represents the end-to-end HBP data lifecycle, covering data ingestion, storage, transformation, and serving.

📄 View the full architecture diagram:
[data/raw/hbp_data_lifecycle.pdf](data/raw/hbp_data_lifecycle.pdf)

This pipeline follows a modern ELT approach:

* Data is ingested from source systems using Airbyte
* Stored in a centralized warehouse (BigQuery)
* Transformed using dbt into analytics-ready models
* Served via BI tools like Metabase for reporting and decision-making


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
