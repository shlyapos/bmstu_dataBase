-- DELETE

-- 01 Simple
-- Удалить лишние посты про вареники, которые добавлены раньше
DELETE FROM post
WHERE title = 'vareniki';

SELECT * FROM post WHERE title = 'vareniki';

-- 02 Complex
-- Удаление из базы плохих комментариев за старые посты
DELETE FROM review
WHERE post_id IN 
(
	SELECT post_id FROM post
	WHERE public_date <= '2000-01-01'
) AND rating <= 3;

SELECT COUNT(*) FROM review;