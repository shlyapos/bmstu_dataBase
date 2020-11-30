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
)