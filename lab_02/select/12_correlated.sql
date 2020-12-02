-- Вывод информации о коментаторе
SELECT account.login, review.rating, review.post_id
FROM account JOIN
(
	review JOIN post
	ON review.post_id = post.post_id
) ON account.account_id = review.author_id