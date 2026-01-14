/*
Purpose:
Demonstrate advanced SQL techniques including:
- CTEs
- Window functions (ROW_NUMBER)
- Deduplication logic
- Deterministic tie-breaking
- Ordered aggregation into a delimited list

Use case:
For each member (MRN), identify the most recent records,
remove duplicates, and build an ordered list of codes.
*/

WITH raw_data AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY record_date DESC, record_id ASC) AS row_id,
        member_id,
        record_date,
        category_code
    FROM sample_source_table
),

-- Rank rows per member by latest date, then by deterministic row_id
ranked_rows AS (
    SELECT
        row_id,
        member_id,
        record_date,
        category_code,
        ROW_NUMBER() OVER (
            PARTITION BY member_id
            ORDER BY record_date DESC, row_id ASC
        ) AS member_rank,

        ROW_NUMBER() OVER (
            PARTITION BY member_id, record_date, category_code
            ORDER BY row_id ASC
        ) AS exact_dup_rank
    FROM raw_data
),

-- Aggregate codes per member in chronological order
aggregated_codes AS (
    SELECT
        member_id,
        LISTAGG(category_code, ',') WITHIN GROUP (
            ORDER BY record_date ASC, row_id ASC
        ) AS merged_codes
    FROM ranked_rows
    WHERE exact_dup_rank = 1
    GROUP BY member_id
)

SELECT *
FROM aggregated_codes;
