CREATE TABLE pessoas (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(3),
    last_name VARCHAR(3),
    estado VARCHAR(3)
);

CREATE
OR REPLACE FUNCTION random_estado() RETURNS VARCHAR(3) AS $$
BEGIN RETURN CASE
        floor(random() * 5)
        WHEN 0 THEN 'SP'
        WHEN 1 THEN 'RJ'
        WHEN 2 THEN 'MG'
        WHEN 3 THEN 'ES'
        ELSE 'DF'
    END;

END;

$$ LANGUAGE plpgsql;

-- Inserir dados na tabela pessoas com estados aleatórios
INSERT INTO pessoas (first_name, last_name, estado)
SELECT substring(md5(random()::text), 0, 3),
    substring(md5(random()::text), 0, 3),
    random_estado()
FROM generate_series(1, 10000000);

CREATE TABLE pessoas_partition_range (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(3),
    last_name VARCHAR(3),
    estado VARCHAR(3)
) PARTITION BY RANGE (id);

CREATE TABLE pessoas_part1 PARTITION OF pessoas_partition_range FOR
VALUES
FROM (MINVALUE) TO (2000001);

CREATE TABLE pessoas_part2 PARTITION OF pessoas_partition_range FOR
VALUES
FROM (2000001) TO (4000001);

CREATE TABLE pessoas_part3 PARTITION OF pessoas_partition_range FOR
VALUES
FROM (4000001) TO (6000001);

CREATE TABLE pessoas_part4 PARTITION OF pessoas_partition_range FOR
VALUES
FROM (6000001) TO (8000001);

CREATE TABLE pessoas_part5 PARTITION OF pessoas_partition_range FOR
VALUES
FROM (8000001) TO (MAXVALUE);

INSERT INTO pessoas_partition_range (first_name, last_name, estado)
SELECT substring(md5(random()::text), 0, 3),
    substring(md5(random()::text), 0, 3),
    random_estado()
FROM generate_series(1, 10000000);

CREATE TABLE pessoas_partition_list (
    id SERIAL,
    first_name VARCHAR(3),
    last_name VARCHAR(3),
    estado VARCHAR(3),
    PRIMARY KEY (id, estado)
) PARTITION BY LIST (estado);

-- Criar as partições
CREATE TABLE pessoas_sp PARTITION OF pessoas_partition_list FOR
VALUES IN ('SP');

CREATE TABLE pessoas_rj PARTITION OF pessoas_partition_list FOR
VALUES IN ('RJ');

CREATE TABLE pessoas_mg PARTITION OF pessoas_partition_list FOR
VALUES IN ('MG');

CREATE TABLE pessoas_es PARTITION OF pessoas_partition_list FOR
VALUES IN ('ES');

CREATE TABLE pessoas_df PARTITION OF pessoas_partition_list FOR
VALUES IN ('DF');