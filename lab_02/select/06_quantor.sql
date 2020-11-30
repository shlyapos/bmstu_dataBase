-- Получение списка отзывов, где выставлен рейтинг ниже любого 
-- рейтинга пользователя с id 23
SELECT post_id, review_data, rating
FROM review WHERE rating < ALL
(
	SELECT rating FROM review
	WHERE author_id = 23
)