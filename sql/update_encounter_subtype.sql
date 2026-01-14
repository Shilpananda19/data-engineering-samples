/*
Purpose:
Populate encounter_subtype in fact_encounters table
by joining with utilization reference data.
Processes data year-by-year for controlled updates.

Author: Sample Data Engineering Project
*/

DECLARE
    v_start_date DATE;
    v_end_date   DATE;
    v_start_time TIMESTAMP;
    v_end_time   TIMESTAMP;
BEGIN
    -- Loop through years (example range)
    FOR yr IN 2020 .. 2024 LOOP

        v_start_date := TO_DATE('01-JAN-' || yr, 'DD-MON-YYYY');
        v_end_date   := TO_DATE('31-DEC-' || yr, 'DD-MON-YYYY');

        v_start_time := SYSTIMESTAMP;

        DBMS_OUTPUT.PUT_LINE(
            'Year ' || yr || ' - Update started at: ' ||
            TO_CHAR(v_start_time, 'YYYY-MM-DD HH24:MI:SS.FF')
        );

        -- Update encounter subtype using reference table
        UPDATE fact_encounters fe
        SET encounter_subtype = (
            SELECT u.encounter_subtype
            FROM ref_utilization u
            WHERE u.source_system = 'APP_A'
              AND u.encounter_id = fe.encounter_id
        )
        WHERE fe.encounter_subtype IS NULL
          AND fe.source_system = 'APP_A'
          AND fe.encounter_date BETWEEN v_start_date AND v_end_date;

        COMMIT;

        v_end_time := SYSTIMESTAMP;

        DBMS_OUTPUT.PUT_LINE(
            'Year ' || yr || ' - Update ended at: ' ||
            TO_CHAR(v_end_time, 'YYYY-MM-DD HH24:MI:SS.FF')
        );

    END LOOP;
END;
/
