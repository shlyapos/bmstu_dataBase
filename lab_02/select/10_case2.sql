-- Вывод статуса поста на основе оценки поста
SELECT post.post_id, title,
	CASE 
		WHEN rating > 7 THEN 'hot' 
		WHEN rating > 4 THEN 'harosh'
		WHEN rating > 1 THEN 'wicked'
		ELSE 'trash'
	END AS post_rating
FROM post
JOIN review ON post.post_id = review.post_id