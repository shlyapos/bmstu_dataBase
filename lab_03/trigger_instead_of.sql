-- 02 Trigger on INSTEAD OF
-- Не пропускает и удаляет слишком негативные обзоры на пост
DROP TABLE IF EXISTS review_copy CASCADE;
SELECT * INTO TEMP TABLE review_copy FROM review;

CREATE VIEW review_view AS
SELECT * FROM review_copy;

CREATE OR REPLACE FUNCTION delete_bad_review() RETURNS TRIGGER AS
$$
BEGIN
	DELETE FROM review_view
	WHERE review_copy.review_id = OLD.id AND NEW.rating < 1;
	
	RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER on_bad_review
	INSTEAD OF UPDATE OR INSERT ON review_view
	FOR EACH ROW
	EXECUTE PROCEDURE delete_bad_review();