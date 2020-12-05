-- 01 Simple procedure
-- Удвление старых обзоров
DROP TABLE IF EXISTS review_copy;
SELECT * INTO TEMP review_copy
FROM review;

CREATE OR REPLACE PROCEDURE delete_old_reviews() AS 
$$
	DELETE FROM review_copy
	WHERE public_date < '2000-01-01';
$$ LANGUAGE SQL;

CALL delete_old_reviews();

SELECT * FROM review_copy
WHERE public_date < '2000-01-01';


-- 02 Recursive procedure
-- Обновить даты для постов с хорошей средней оценкой
DROP TABLE IF EXISTS post_copy;
SELECT * INTO TEMP post_copy
FROM post;

CREATE OR REPLACE PROCEDURE update_date(start_id INT, end_id INT) AS
$$
BEGIN
	IF (start_id <= end_id)
	THEN
		UPDATE post_copy
		SET public_date = current_date
		WHERE post_id = start_id AND 
		public_date < '2000-01-01'
		AND 
		(
			SELECT AVG(rating) FROM review
			GROUP BY (review.post_id)
			HAVING review.post_id = post_copy.post_id
		) > 5;
		
		CALL update_date(start_id + 1, end_id);
	END IF;
END;
$$ LANGUAGE PLPGSQL;

CALL update_date(20, 200);

SELECT * FROM post_copy
WHERE post_id BETWEEN 20 AND 200
AND public_date = current_date;


-- 03 Cursor procedure
-- Понижение объективности у пользователя при многочисленных низких оценках
DROP TABLE IF EXISTS account_copy;
SELECT * INTO TEMP TABLE account_copy FROM account;

ALTER TABLE account_copy
ADD honesty INT NOT NULL DEFAULT(100);

CREATE OR REPLACE PROCEDURE update_honesty(low_rat INT, val INT) AS 
$$
DECLARE reviewer_cursor CURSOR
	FOR 
		SELECT account_copy.*, rating
		FROM account_copy
		JOIN review
		ON review.author_id = account_copy.account_id
		WHERE rating < low_rat;
	ROW RECORD;

BEGIN
	OPEN reviewer_cursor;
	
	LOOP
		FETCH reviewer_cursor INTO ROW;
		EXIT WHEN NOT FOUND;
		
		UPDATE account_copy
		SET honesty = ROW.honesty - val
		WHERE account_copy.account_id = ROW.account_id;
	END LOOP;
	
	CLOSE reviewer_cursor;
END
$$ LANGUAGE PLPGSQL;

CALL update_honesty(2, 3);

SELECT * FROM account_copy WHERE author_id = 1;


-- 04 Metadata procedure
-- Получить названия всех ограничений в столбцах и таблицах
CREATE OR REPLACE PROCEDURE get_metadata() AS 
$$
DECLARE
	row RECORD;
BEGIN
	FOR row IN (SELECT table_name, column_name, constraint_name
	 			FROM information_schema.constraint_column_usage
				WHERE constraint_schema NOT IN ('information_schema', 'pg_catalog'))
	LOOP
		RAISE NOTICE '{table: %} {column: %} {constraint: %}', row.table_name, row.column_name, row.constraint_name;
	END LOOP;
END
$$ LANGUAGE PLPGSQL;

CALL get_metadata();

