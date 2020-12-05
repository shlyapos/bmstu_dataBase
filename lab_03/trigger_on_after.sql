-- 01 Trigger on AFTER
-- С ростом средней оценки, увеличивается статус интересности поста
DROP TABLE IF EXISTS post_copy;
SELECT * INTO TEMP post_copy FROM post;

ALTER TABLE post_copy
ADD hot_status INT NOT NULL DEFAULT(1000);

CREATE OR REPLACE FUNCTION update_hot_status() RETURNS TRIGGER AS
$$
BEGIN
	IF (NEW.rating > 5)
	THEN
		UPDATE post_copy
		SET hot_status = hot_status - 1
		WHERE post_copy.post_id = NEW.post_id;
	ELSE
		UPDATE post_copy
		SET hot_status = hot_status + 1
		WHERE post_copy.post_id = NEW.post_id;
	END IF;
	
	RETURN NEW;	
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER on_rating
	AFTER INSERT ON review
	FOR EACH ROW
	EXECUTE PROCEDURE update_hot_status();

SELECT * FROM post_copy ORDER BY hot_status;

INSERT INTO review (post_id, author_id, review_data, rating, public_date) VALUES (2, 23, 'kruta', 10, current_date);