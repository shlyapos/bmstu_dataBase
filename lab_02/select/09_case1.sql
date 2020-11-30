-- Вывод актальности отзывов
SELECT review_data, 
	CASE (public_date > '2019-01-01')
		WHEN true THEN 'new'
		ELSE 'old'
	END AS status
FROM review;