# Data Engineering Samples

This repository contains representative examples of my data engineering work,
using mock and public datasets. All examples are sanitized and do not include
proprietary or employer data.

---

## Problem

Business and product teams often need reliable, analytics-ready datasets
derived from raw transactional data. Common challenges include:
- Complex business rules
- Performance optimization
- Reusable data models
- Automated, reliable ETL pipelines

---

## Approach

### SQL

- Designed dimensional-style data models using CTEs
- Applied window functions for rolling metrics
- Optimized queries for analytics use cases
- Designed dimensional-style data models using CTEs
- Applied window functions for rolling metrics
- Optimized queries for analytics use cases

- -- Fact table
CREATE TABLE fact_encounters (
    encounter_id        NUMBER PRIMARY KEY,
    encounter_date      DATE,
    encounter_subtype   VARCHAR2(50),
    source_system       VARCHAR2(20)
);

-- Reference / utilization table
CREATE TABLE ref_utilization (
    encounter_id        NUMBER,
    encounter_subtype   VARCHAR2(50),
    source_system       VARCHAR2(20)
);

-- Sample partitioned table
CREATE TABLE fact_lab_results (
    result_id     NUMBER,
    result_date   DATE,
    result_value  NUMBER
)
PARTITION BY RANGE (result_date) (
    PARTITION p_2023 VALUES LESS THAN (DATE '2024-01-01'),
    PARTITION p_2024 VALUES LESS THAN (DATE '2025-01-01')
);

-- Sample partitioned index
CREATE INDEX idx_fact_lab_results
ON fact_lab_results (result_date)
LOCAL;

