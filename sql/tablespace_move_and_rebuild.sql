/*
Purpose:
Demonstrate how to move tables and partitions to a new tablespace
and rebuild associated indexes, including partitioned indexes,
using dynamic SQL.

This script is intended for learning and portfolio demonstration.
*/

------------------------------------------------------------
-- Example: Move a table partition to a new tablespace
------------------------------------------------------------
ALTER TABLE fact_lab_results
MOVE PARTITION p_2024
TABLESPACE analytics_data_ts;

------------------------------------------------------------
-- Example: Move entire table to a new tablespace
------------------------------------------------------------
ALTER TABLE sample_schema.sample_table
MOVE TABLESPACE analytics_data_ts;

------------------------------------------------------------
-- Example: Rebuild a non-partitioned index
------------------------------------------------------------
ALTER INDEX idx_sample_table_col1
REBUILD TABLESPACE analytics_index_ts;

------------------------------------------------------------
-- Example: Rebuild a specific partition of a partitioned index
------------------------------------------------------------
ALTER INDEX idx_lab_notes
REBUILD PARTITION p_2023
TABLESPACE analytics_index_ts;

------------------------------------------------------------
-- Dynamic rebuild of ALL partitions for a partitioned index
------------------------------------------------------------
DECLARE
    CURSOR part_cur IS
        SELECT partition_name
        FROM all_ind_partitions
        WHERE index_name  = 'IDX_FACT_LAB_RESULTS'
          AND index_owner = 'ANALYTICS_SCHEMA';

BEGIN
    FOR part_rec IN part_cur LOOP
        EXECUTE IMMEDIATE
            'ALTER INDEX ANALYTICS_SCHEMA.IDX_FACT_LAB_RESULTS ' ||
            'REBUILD PARTITION ' || part_rec.partition_name ||
            ' TABLESPACE analytics_index_ts';

        DBMS_OUTPUT.PUT_LINE(
            'Rebuilt partition: ' || part_rec.partition_name
        );
    END LOOP;
END;
/
