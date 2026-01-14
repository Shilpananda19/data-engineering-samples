/*
Purpose:
Incrementally load new records from source to target table
with start/end timestamps and row counts.
*/

DECLARE
    v_start_time   TIMESTAMP;
    v_end_time     TIMESTAMP;
    v_rows_loaded  NUMBER;
BEGIN
    v_start_time := SYSTIMESTAMP;

    INSERT INTO target_table (
        record_id,
        record_date,
        amount
    )
    SELECT
        record_id,
        record_date,
        amount
    FROM source_table
    WHERE record_date > (
        SELECT NVL(MAX(record_date), DATE '1900-01-01')
        FROM target_table
    );

    v_rows_loaded := SQL%ROWCOUNT;
    COMMIT;

    v_end_time := SYSTIMESTAMP;

    INSERT INTO etl_audit_log (
        job_name,
        start_time,
        end_time,
        rows_processed,
        status
    )
    VALUES (
        'INCREMENTAL_LOAD_JOB',
        v_start_time,
        v_end_time,
        v_rows_loaded,
        'SUCCESS'
    );

    COMMIT;
END;
/
