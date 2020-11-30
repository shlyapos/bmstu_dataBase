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