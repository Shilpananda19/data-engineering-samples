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

