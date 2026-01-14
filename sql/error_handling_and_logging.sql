/*
Purpose:
Demonstrate structured exception handling
and centralized error logging.
*/

BEGIN
    -- Simulated business logic
    UPDATE orders_fact
    SET order_status = 'COMPLETED'
    WHERE order_date < SYSDATE - 30;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        INSERT INTO error_log (
            error_message,
            error_code,
            error_date
        )
        VALUES (
            SQLERRM,
            SQLCODE,
            SYSDATE
        );

        ROLLBACK;
        RAISE;
END;
/
