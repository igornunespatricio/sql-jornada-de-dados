SELECT first_name
FROM pessoas
WHERE middle_name LIKE '%a%';

explain analyze
SELECT first_name
FROM pessoas
WHERE middle_name LIKE '%a%';