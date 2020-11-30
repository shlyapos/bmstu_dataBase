-- Поиск отзывов, где оценка между 1 и 5
SELECT login, rating FROM account
INNER JOIN review ON account.account_id = review.review_id
WHERE rating BETWEEN 1 AND 5;