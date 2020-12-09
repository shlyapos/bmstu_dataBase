DROP TABLE IF EXISTS post_copy1;
DROP TABLE IF EXISTS post_copy2;


-- 01 Извлечение данных в JSON
COPY (SELECT ROW_TO_JSON(post) FROM post)
TO 'C:\Repositories\bmstu_dataBase\lab_05\json_src\post.json';


-- 02 Загрузка JSON файла в таблицу
CREATE TEMP TABLE post_copy1(doc JSON);
COPY post_copy1 FROM 'C:\Repositories\bmstu_dataBase\lab_05\json_src\post.json';


-- 02 Сохранение данных в таблицу
CREATE TABLE IF NOT EXISTS post_copy2(LIKE post INCLUDING ALL);
INSERT INTO post_copy2
SELECT p.*
FROM post_copy1, json_populate_record(null::post, doc) AS p;


-- 02 Проверка на совпадение
(
	SELECT * FROM post_copy2
	EXCEPT
	SELECT * FROM post
)
UNION
(
	SELECT * FROM post
	EXCEPT
	SELECT * FROM post_copy2
)

