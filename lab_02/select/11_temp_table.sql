-- Получение всех пользователей, которые ставят плохие оценки
DROP TABLE bad_reviewers;

SELECT login, email, rating 
INTO TEMP bad_reviewers
FROM account JOIN review ON account.account_id = review.author_id
WHERE rating < 3;

SELECT * FROM bad_reviewers;