-- Вывод средней оценки постов за определённые года
SELECT AVG(rating) AS rating_average, date_part('year', public_date) AS post_year
FROM review GROUP BY Post_Year;