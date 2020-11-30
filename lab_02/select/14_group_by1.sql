-- Вывести для каждого тега количество текстов
SELECT tag_name, COUNT(*) FROM tag
JOIN tag_to_text ON tag_to_text.tag_id = tag.tag_id
GROUP BY tag_name;