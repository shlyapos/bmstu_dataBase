-- INSERTS

-- 01 Simple 
-- Вставка нового поля в таблицу post
INSERT INTO post (author_id, title, public_date) VALUES (3, 'vareniki', current_date);

SELECT * FROM post WHERE author_id = 3;

-- 02 Complex
-- Добавление нового обзора автор, которого имеет малое кол-во обзоров
INSERT INTO review(post_id, author_id, review_data, rating, public_date)
SELECT post_id, 
(
	SELECT account_id
	FROM account
	WHERE account_id =
	(
		SELECT author_id
		GROUP BY author_id
		ORDER BY COUNT(*)
		LIMIT 1
	)
), 'kruta', 3, current_date
FROM review
WHERE review_id = 100;

DELETE FROM review WHERE review_data = 'kruta'

SELECT * FROM review WHERE review_data LIKE 'kruta';