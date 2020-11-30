-- Вывести количество картинок и текста для каждого тэга
SELECT tag_name, 
(
	SELECT COUNT(*) 
	FROM tag_to_picture
	WHERE tag_to_picture.tag_id = tag.tag_id
) AS picture_count,
(
	SELECT COUNT(*)
	FROM tag_to_text
	WHERE tag_to_text.tag_id = tag.tag_id
) AS text_count
FROM tag;

