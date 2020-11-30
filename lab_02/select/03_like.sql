-- Вывод тэгов картинок с расширением png 
SELECT tag_name, picture_path FROM picture 
	JOIN tag_to_picture ON tag_to_picture.picture_id = picture.picture_id
	JOIN tag ON tag_to_picture.tag_id = tag.tag_id
WHERE picture_path LIKE '%.png';