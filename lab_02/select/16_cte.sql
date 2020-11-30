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