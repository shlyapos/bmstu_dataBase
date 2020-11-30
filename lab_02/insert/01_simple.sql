-- Вставка нового поля в таблицу post
INSERT INTO post (author_id, title, public_date) VALUES (3, 'vareniki', current_date);

SELECT * FROM post WHERE author_id = 3;