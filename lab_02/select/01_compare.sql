-- Поиск отзывов позже 2016 г.
SELECT login FROM account
INNER JOIN review ON account.account_id = review.review_id
WHERE public_date > '2016-01-01';