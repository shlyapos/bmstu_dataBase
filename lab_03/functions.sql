-- 01 Scalar function
-- Подсчёт кол-ва постов
CREATE OR REPLACE FUNCTION get_number_post() RETURNS BIGINT AS $$
	SELECT COUNT(*)
	FROM post
$$ LANGUAGE SQL;

SELECT get_number_post();


-- 02 Inline table function
-- Вывод логина о пользователе по входному id
CREATE OR REPLACE FUNCTION get_login(id_ INTEGER) RETURNS VARCHAR AS $$
	SELECT login
	FROM account
	WHERE account.account_id = id_
$$ LANGUAGE SQL;

SELECT * FROM get_login(134);


-- 03 Multioperator table function
-- Вывод состояния поста на момент времени вызова функции
DROP TABLE post_information;
CREATE TEMP TABLE IF NOT EXISTS post_information
(
	post_id 		INT,
	title			VARCHAR,
	public_date 	DATE,
	author_login 	VARCHAR,
	email 			VARCHAR,
	avg_rating		FLOAT,
	adding_time		TIMESTAMP,
	PRIMARY KEY (post_id, adding_time)
);

CREATE OR REPLACE FUNCTION get_post_information(INT) RETURNS TABLE
(
	post_id 		INT,
	title			VARCHAR,
	public_date 	DATE,
	author_login 	VARCHAR,
	email 			VARCHAR,
	avg_rating		FLOAT,
	adding_time		TIMESTAMP
) AS 
$$
	INSERT INTO post_information
	SELECT 
		post.post_id,
		post.title,
		post.public_date,
		account.login,
		account.email,
		ROUND(
			(
				SELECT AVG(rating) 
				FROM review
				GROUP BY review.post_id
				HAVING review.post_id = post.post_id
			), 3
		),
		current_timestamp
		FROM post
		JOIN account
		ON account.account_id = post.author_id;
	
	SELECT * FROM post_information
	WHERE post_id = $1;
$$ LANGUAGE SQL;

SELECT * FROM get_post_information(210);

-- 04 Recursive function
-- Получение глубины обзоров
CREATE OR REPLACE FUNCTION get_review_depth(id_ INT, depth_ INT = 1) RETURNS INT AS 
$$
BEGIN
	IF EXISTS (SELECT * FROM review WHERE review.parent_id != NULL AND review.review_id = id_)
	THEN 
		CALL get_review_depth(review.parent_id, depth_ + 1);
	ELSE
		RETURN depth_;
	END IF;
END;
$$ language plpgsql;

SELECT * FROM get_review_depth(3);
	