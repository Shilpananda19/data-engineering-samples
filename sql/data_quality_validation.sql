/*
Purpose:
Validate critical columns and log failures
before downstream processing.
*/

DECLARE
    v_invalid_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_invalid_count
    FROM customer_dim
    WHERE customer_id IS NULL
       OR email IS NULL;

    IF v_invalid_count > 0 THEN
        INSERT INTO data_quality_log (
            check_name,
            error_count,
            check_date
        )
        VALUES (
            'CUSTOMER_NULL_CHECK',
            v_invalid_count,
            SYSDATE
        );

        RAISE_APPLICATION_ERROR(
            -20001,
            'Data quality validation failed'
        );
    END IF;

    DBMS_OUTPUT.PUT_LINE('Data quality checks passed');
END;
/
