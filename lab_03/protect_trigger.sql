-- На защиту дали триггер, который не допускает команду DELETE 
-- и вместо выполнения выдаёт сообщение
CREATE VIEW review_view
SELECT * FROM review;

CREATE OR REPLACE FUNCTION print_message() RETURNS TRIGGER AS
$$
BEGIN
    RAISE NOTICE 'Wrong command';
    RETURN NULL;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER on_delete_command
    INSTEAD OF DELETE ON review_view
    FOR EACH ROW
	EXECUTE PROCEDURE print_message();