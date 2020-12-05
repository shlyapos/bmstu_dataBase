-- SELECTS

-- 01 Compare
-- Поиск отзывов позже 2016 г.
SELECT login, public_date FROM account
INNER JOIN review ON account.account_id = review.review_id
WHERE date_part('year', public_date) > '2016';

-- 02 Between
-- Поиск отзывов, где оценка между 1 и 5
SELECT login, rating FROM account
INNER JOIN review ON account.account_id = review.review_id
WHERE rating BETWEEN 1 AND 5;

-- 03 LIKE
-- Вывод тэгов картинок с расширением png 
SELECT tag_name, picture_path FROM picture 
	JOIN tag_to_picture ON tag_to_picture.picture_id = picture.picture_id
	JOIN tag ON tag_to_picture.tag_id = tag.tag_id
WHERE picture_path LIKE '%.png';

-- 04 IN
-- Вывод логинов пользователей, id и даты публикации постов которые выложены
-- не позже 2019 года
SELECT login, post_id, public_date FROM account
JOIN post ON post.author_id = account.account_id
WHERE post_id IN
(
	SELECT post_id 
	FROM post WHERE public_date > '2019-01-01'
);

-- 05 EXISTS
-- Поиск постов, у которых нет комментариев
SELECT post_id, title, public_date FROM post
WHERE NOT EXISTS
(
	SELECT post_id FROM review
	WHERE review.post_id = post.post_id
);

-- 06 Quantor
-- Получение списка отзывов, где выставлен рейтинг ниже любого 
-- рейтинга пользователя с id 23
SELECT post_id, review_data, rating
FROM review WHERE rating < ALL
(
	SELECT rating FROM review
	WHERE author_id = 23
);

-- 07 AVG
-- Вывод средней оценки постов за определённые года
SELECT AVG(rating) AS rating_average, date_part('year', public_date) AS post_year
FROM review GROUP BY Post_Year;

-- 08 Scalar
-- Вывести количество картинок и текста для каждого тэга
SELECT tag_name, 
(
	SELECT COUNT(*) 
	FROM tag_to_picture
	WHERE tag_to_picture.tag_id = tag.tag_id
) AS picture_count,
(
	SELECT COUNT(*)
	FROM tag_to_text
	WHERE tag_to_text.tag_id = tag.tag_id
) AS text_count
FROM tag;

-- 09 SIMPLE CASE
-- Вывод актальности отзывов
SELECT review_data, 
	CASE (public_date > '2019-01-01')
		WHEN true THEN 'new'
		ELSE 'old'
	END AS status
FROM review;

-- 10 COMPLEX CASE
-- Вывод статуса поста на основе оценки поста
SELECT post.post_id, title,
	CASE 
		WHEN rating > 7 THEN 'hot' 
		WHEN rating > 4 THEN 'harosh'
		WHEN rating > 1 THEN 'wicked'
		ELSE 'trash'
	END AS post_rating
FROM post
JOIN review 
ON post.post_id = review.post_id;

-- 11 TEMP TABLE
-- Получение всех пользователей, которые ставят плохие оценки
DROP TABLE bad_reviewers;

SELECT login, email, rating 
INTO TEMP bad_reviewers
FROM account JOIN review ON account.account_id = review.author_id
WHERE rating < 3;

SELECT * FROM bad_reviewers;

-- 12 Correlated
-- Вывод информации о коментаторе
SELECT account.login, review.rating, review.post_id
FROM account JOIN
(
	review JOIN post
	ON review.post_id = post.post_id
) ON account.account_id = review.author_id;

-- 13 Depth 3
-- Вывод комментариев и оценок к постам, которые имеют картинку
-- с тэгами travel, trip или drive
SELECT review_data, rating, public_date FROM review
WHERE review.post_id IN
(
	SELECT post.post_id FROM post
	JOIN picture_to_post ON picture_to_post.post_id = post.post_id
	WHERE picture_to_post.picture_id IN 
	(
		SELECT picture_id FROM tag_to_picture
		WHERE tag_id IN
		(
			SELECT tag_id FROM tag
			WHERE tag_name IN ('travel', 'trip', 'drive')
		)
	)
);

-- 14 GROUP BY 1
-- Вывести для каждого тега количество текстов
SELECT tag_name, COUNT(*) FROM tag
JOIN tag_to_text ON tag_to_text.tag_id = tag.tag_id
GROUP BY tag_name;

-- 15 GROUP BY 2
-- Вывести средний рейтинг постов по тегу текста, при этом рейтинг должен быть
-- больше чем средний рейтинг всех постов в базе
SELECT tag.tag_name, ROUND(AVG(rating), 3) AS avg_rating FROM
(
	SELECT post.post_id, rating FROM review
	JOIN post 
	ON post.post_id = review.post_id
) AS post_rating
JOIN
(
	SELECT post_id, tag_id FROM text_to_post
	JOIN tag_to_text
	ON tag_to_text.text_id = text_to_post.text_id
) AS post_tag

ON post_tag.post_id = post_rating.post_id
JOIN tag ON tag.tag_id = post_tag.tag_id

GROUP BY tag_name
HAVING AVG(rating) > 
(
	SELECT AVG(rating) FROM review
);

-- 16 CTE
-- Вывести авторов постов без комментариев
WITH not_rating_post AS 
(
	SELECT author_id, title, public_date FROM post
	WHERE NOT EXISTS
	(
		SELECT post_id FROM review
		WHERE review.post_id = post.post_id
	)
);

SELECT login, title, public_date FROM not_rating_post
JOIN account 
ON account.account_id = not_rating_post.author_id;

-- 17 CTE recursive
-- Вывод всех предшествующих обзоров к самому первому обзору
ALTER TABLE review ADD COLUMN parent_id;

WITH RECURSIVE previous_review(author_id, review_data, rating) AS
(
	SELECT review.review_id, review.author_id, review.review_data, review.rating
	FROM review AS first_review
	WHERE review.review_id = 1
	
	UNION ALL
	
	SELECT review.review_id, review.author_id, review.review_data, review.rating
	FROM review
	JOIN first_review
	ON first_review.parent_id = review.review_id
);

SELECT * FROM previous_review;

-- 18 Window 1
-- Вывод пользователей, по убыванию даты отправления комментария
-- также вывод средней оценки пользователя
SELECT *
FROM
(
	SELECT login, 
		MAX(public_date) OVER (PARTITION BY author_id) AS last_public_date,
		ROUND(AVG(rating) OVER (PARTITION BY author_id), 3) AS average_rating
	FROM account JOIN review
	ON review.author_id = account.account_id
) AS reviewers
ORDER BY last_public_date DESC;

-- 19 Window 2
-- Получение пользователей с одним комментарием
SELECT account.*, ROW_NUMBER() OVER (PARTITION BY login) AS count_review
INTO TEMP TABLE account_temp
FROM account 
JOIN review
ON review.author_id = account.account_id;

DELETE FROM account_temp
WHERE count_review > 1;