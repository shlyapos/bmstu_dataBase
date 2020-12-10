-- 04_1 Извлечь JSON фрагмент из JSON документа
-- Вывести количество л.с. автомобиля
SELECT *
FROM json_extract_path('{"name": "Volga", "Storage": "Storage324", "Properties": {"Number": "B004KO", "Color": "Red", "Engine": 78}}', 
					   'Properties', 'Engine');
					   
					   
-- 04_2 Извлечь значения конкретных узлов или атрибутов JSON документа
-- Вывести заголовок поста, страну и компанию, при этом компания начинается с A  
SELECT DISTINCT title, (data_json->>'country') AS country, (data_json->>'company') AS company
FROM post_copy
WHERE data_json->>'company' LIKE 'A%';


-- 04_3 Выполнить проверку существования узла или атрибута
-- Вывести заголовок и компанию поста, где проставлено поле страна
SELECT DISTINCT title, (data_json->>'company') AS company
FROM post_copy
WHERE data_json::jsonb ? 'country';


-- 04_4 Изменить JSON документ
-- Удаление параметра about
UPDATE post_copy
SET data_json = data_json::jsonb - 'about';

SELECT * FROM post_copy;

-- 04_5 Разделить JSON документ на несколько строк по узлам
-- Размещение данных об автомобиле в таблицу вида key - values
SELECT *
FROM json_each_text('{"name": "Volga", "Storage": "Storage324", "Properties": {"Number": "B004KO", "Color": "Red", "Engine": 78}}');