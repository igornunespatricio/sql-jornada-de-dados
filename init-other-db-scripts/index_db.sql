CREATE TABLE IF NOT EXISTS pessoas (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(3),
    middle_name VARCHAR(3),
    last_name VARCHAR(3)
);

INSERT INTO pessoas (first_name, middle_name, last_name)
SELECT substring(md5(random()::text), 0, 3),
    substring(md5(random()::text), 0, 3),
    substring(md5(random()::text), 0, 3)
FROM generate_series(1, 1000000);

CREATE INDEX IF NOT EXISTS idx_first_name ON pessoas (first_name);