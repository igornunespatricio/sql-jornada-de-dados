-- create materialized view
CREATE materialized VIEW regions AS
SELECT
    region_id,
    region_description
FROM
    region;


-- see the materialized view
SELECT
    *
FROM
    regions;


-- insert into table which is source of materialized view
INSERT INTO
    region
VALUES
    (10, 'Europe');


-- querying materialized view won't show new region
SELECT
    *
FROM
    regions;


-- refreshing materialized view
REFRESH MATERIALIZED VIEW regions;


-- now querying materialized view will show new region
SELECT
    *
FROM
    regions;