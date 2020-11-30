-- Обновить для записи с id 5 поле рейтинга на среднюю оценку
-- по всем постам
UPDATE review
SET rating = 
(
	SELECT AVG(rating)
	FROM review
)
WHERE review_id = 5;

SELECT * FROM review WHERE review_id = 5;