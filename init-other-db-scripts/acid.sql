-- Criar tabela
CREATE TABLE IF NOT EXISTS exemplo (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50)
);

-- Inserir dados
INSERT INTO exemplo (nome)
VALUES ('A'),
    ('B'),
    ('C');

SELECT *
FROM exemplo