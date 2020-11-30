-- Изменение рейтинга для комментария с id 5
UPDATE review 
SET rating = rating * 0.5
WHERE review_id = 5;