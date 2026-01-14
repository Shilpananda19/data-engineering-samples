/*
Purpose:
Move table partitions to a new tablespace
and rebuild corresponding index partitions.
*/

DECLARE
    CURSOR part_cur IS
        SELECT partition_name
        FROM user_tab_partitions
        WHERE table_name = 'SALES_FACT';

BEGIN
    FOR p IN part_cur LOOP
        EXECUTE IMMEDIATE
            'ALTER TABLE SALES_FACT MOVE PARTITION '
            || p.partition_name
            || ' TABLESPACE DATA_TS';

        EXECUTE IMMEDIATE
            'ALTER INDEX SALES_FACT_IDX REBUILD PARTITION '
            || p.partition_name
            || ' TABLESPACE INDEX_TS';

        DBMS_OUTPUT.PUT_LINE('Processed partition: ' || p.partition_name);
    END LOOP;
END;
/
