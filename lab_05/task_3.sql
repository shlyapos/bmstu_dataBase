-- 03 

DROP TABLE post_copy;
CREATE TABLE post_copy (LIKE post INCLUDING ALL);

INSERT INTO post_copy
SELECT post.*
FROM post;


-- Добавление столбца в таблицу
ALTER TABLE post_copy ADD COLUMN data_json JSON;


-- Импорт таблицы из формата JSON во временную
DROP TABLE post_json;

CREATE TEMP TABLE post_json(id SERIAL, doc JSON);
COPY post_json(doc) FROM 'C:\Repositories\bmstu_dataBase\lab_05\json_src\data_task3.json';


-- Добавление столбца в таблицу
UPDATE post_copy
SET data_json = (SELECT doc FROM post_json WHERE post_copy.post_id = post_json.id);