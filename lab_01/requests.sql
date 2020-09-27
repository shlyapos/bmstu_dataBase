DROP TABLE IF EXISTS account CASCADE;
DROP TABLE IF EXISTS post_text CASCADE;
DROP TABLE IF EXISTS tag CASCADE;
DROP TABLE IF EXISTS picture CASCADE;
DROP TABLE IF EXISTS review CASCADE;
DROP TABLE IF EXISTS post CASCADE;

DROP TABLE IF EXISTS tag_to_picture CASCADE;
DROP TABLE IF EXISTS picture_to_post CASCADE;

DROP TABLE IF EXISTS tag_to_text CASCADE;
DROP TABLE IF EXISTS text_to_post CASCADE;

CREATE TABLE IF NOT EXISTS account (
	account_id 	SERIAL 		NOT NULL PRIMARY KEY,
	login 		VARCHAR(32)	NOT NULL UNIQUE,
	email 		VARCHAR(64)	NOT NULL UNIQUE,
	salt 		CHAR(32)	NOT NULL UNIQUE,
	hash		CHAR(64)	NOT NULL
);

CREATE TABLE IF NOT EXISTS post_text (
	text_id 	SERIAL NOT NULL PRIMARY KEY,
	text_data	TEXT
);

CREATE TABLE IF NOT EXISTS picture (
	picture_id 		SERIAL 		NOT NULL PRIMARY KEY,
	picture_path	VARCHAR(64) UNIQUE
);

CREATE TABLE IF NOT EXISTS tag (
	tag_id 		SERIAL 		NOT NULL PRIMARY KEY,
	tag_name	VARCHAR(32)	NOT NULL
);

CREATE TABLE IF NOT EXISTS post (
	post_id 	SERIAL 		NOT NULL PRIMARY KEY,
	author_id 	INTEGER 	NOT NULL REFERENCES account(account_id),
	title		VARCHAR(32) NOT NULL,
	public_date	DATE		NOT NULL
); 

CREATE TABLE IF NOT EXISTS review (
	review_id 	SERIAL 	NOT NULL PRIMARY KEY,
	post_id 	INTEGER NOT NULL REFERENCES post(post_id),
	author_id 	INTEGER NOT NULL REFERENCES account(account_id),
	review_data	TEXT	NOT NULL,
	rating		INTEGER	NOT NULL,
	public_date DATE	NOT NULL,
	CONSTRAINT valid_rating CHECK (rating > 0 AND rating < 11)
);

--Связующие таблицы для картинок

CREATE TABLE IF NOT EXISTS tag_to_picture (
	tag_id 		INTEGER NOT NULL REFERENCES tag(tag_id),
	picture_id	INTEGER NOT NULL REFERENCES picture(picture_id),
	PRIMARY KEY (tag_id, picture_id)
);

CREATE TABLE IF NOT EXISTS picture_to_post (
	post_id 	INTEGER NOT NULL REFERENCES post(post_id),
	picture_id	INTEGER NOT NULL REFERENCES picture(picture_id),
	PRIMARY KEY (post_id, picture_id)
);

--Связующие таблицы для текста

CREATE TABLE IF NOT EXISTS tag_to_text (
	tag_id	INTEGER NOT NULL REFERENCES tag(tag_id),
	text_id	INTEGER NOT NULL REFERENCES post_text(text_id),
	PRIMARY KEY (tag_id, text_id)
);

CREATE TABLE IF NOT EXISTS text_to_post (
	post_id INTEGER NOT NULL REFERENCES post(post_id),
	text_id	INTEGER NOT NULL REFERENCES post_text(text_id),
	PRIMARY KEY (post_id, text_id)
);

COPY post_text(text_data) 
FROM 'C:\Repositories\bmstu_dataBase\lab_01\source\post_text.csv'	WITH (FORMAT csv);
COPY tag(tag_name) 
FROM 'C:\Repositories\bmstu_dataBase\lab_01\source\tag.csv' 		WITH (FORMAT csv);
COPY picture(picture_path) 
FROM 'C:\Repositories\bmstu_dataBase\lab_01\source\picture.csv' 	WITH (FORMAT csv);
COPY account(login, email, salt, hash) 
FROM 'C:\Repositories\bmstu_dataBase\lab_01\source\account.csv' 	WITH (FORMAT csv);
COPY post(author_id, title, public_date) 
FROM 'C:\Repositories\bmstu_dataBase\lab_01\source\post.csv'	 	WITH (FORMAT csv);
COPY review(post_id, author_id, review_data, rating, public_date) 	
FROM 'C:\Repositories\bmstu_dataBase\lab_01\source\review.csv' 		WITH (FORMAT csv);


-- Связующие таблицы
-- Для картинок
COPY tag_to_picture(tag_id, picture_id)
FROM 'C:\Repositories\bmstu_dataBase\lab_01\source\tag_to_picture.csv' WITH (FORMAT csv);
COPY picture_to_post(post_id, picture_id)
FROM 'C:\Repositories\bmstu_dataBase\lab_01\source\tag_to_picture.csv' WITH (FORMAT csv);

-- Для текста
COPY tag_to_text(tag_id, text_id)
FROM 'C:\Repositories\bmstu_dataBase\lab_01\source\tag_to_picture.csv' WITH (FORMAT csv);
COPY text_to_post(post_id, text_id)
FROM 'C:\Repositories\bmstu_dataBase\lab_01\source\tag_to_picture.csv' WITH (FORMAT csv);