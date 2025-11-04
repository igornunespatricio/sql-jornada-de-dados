CREATE TEMPORARY VIEW example_temp_view AS
SELECT
    *
FROM
    orders;


SELECT
    *
FROM
    example_temp_view