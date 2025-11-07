SELECT first_name
FROM pessoas
WHERE middle_name = 'aa';

explain analyze
SELECT first_name
FROM pessoas
WHERE middle_name = 'aa';