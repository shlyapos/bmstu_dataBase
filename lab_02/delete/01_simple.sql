-- Удалить лишние посты про вареники, которые добавлены раньше
DELETE FROM post
WHERE title = 'vareniki';

SELECT * FROM post WHERE title = 'vareniki';