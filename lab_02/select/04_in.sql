-- Вывод логинов пользователей, id и даты публикации постов которые выложены
-- не позже 2019 года
SELECT login, post_id, public_date FROM account
JOIN post ON post.author_id = account.account_id
WHERE post_id IN
(
	SELECT post_id 
	FROM post WHERE public_date > '2019-01-01'
);