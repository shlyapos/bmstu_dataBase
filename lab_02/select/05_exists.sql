-- Поиск постов, у которых нет комментариев
SELECT post_id, title, public_date FROM post
WHERE NOT EXISTS
(
	SELECT post_id FROM review
	WHERE review.post_id = post.post_id
)