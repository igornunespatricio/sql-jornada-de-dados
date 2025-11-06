CREATE TEMPORARY TABLE example_temp_table AS
SELECT
    *
FROM
    region;


SELECT
    *
FROM
    example_temp_table;


INSERT INTO
    example_temp_table
VALUES
    (1, 'Europe');


SELECT
    *
FROM
    example_temp_table;


DROP TABLE example_temp_table;