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