-- table creation Funcionario
CREATE TABLE IF NOT EXISTS Funcionario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    salario DECIMAL(10, 2),
    dtcontratacao DATE
);

-- table creation Funcionario_Auditoria
CREATE TABLE IF NOT EXISTS Funcionario_Auditoria (
    id INT,
    salario_antigo DECIMAL(10, 2),
    novo_salario DECIMAL(10, 2),
    data_de_modificacao_do_salario TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id) REFERENCES Funcionario(id)
);

-- data insertion in funcionario table
INSERT INTO Funcionario (nome, salario, dtcontratacao)
VALUES ('Maria', 5000.00, '2021-06-01');

INSERT INTO Funcionario (nome, salario, dtcontratacao)
VALUES ('João', 4500.00, '2021-07-15');

INSERT INTO Funcionario (nome, salario, dtcontratacao)
VALUES ('Ana', 4000.00, '2022-01-10');

INSERT INTO Funcionario (nome, salario, dtcontratacao)
VALUES ('Pedro', 5500.00, '2022-03-20');

INSERT INTO Funcionario (nome, salario, dtcontratacao)
VALUES ('Lucas', 4700.00, '2022-05-25');

-- trigger for salary audit
CREATE
OR REPLACE FUNCTION registrar_auditoria_salario() RETURNS TRIGGER AS $$
BEGIN
INSERT INTO Funcionario_Auditoria (id, salario_antigo, novo_salario)
VALUES (OLD .id, OLD .salario, NEW .salario);

RETURN NEW;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE TRIGGER trg_salario_modificado AFTER
UPDATE OF salario ON Funcionario FOR EACH ROW EXECUTE FUNCTION registrar_auditoria_salario();

-- Create audit table with column tracking
CREATE TABLE IF NOT EXISTS Funcionario_Auditoria_Geral (
    id SERIAL PRIMARY KEY,
    funcionario_id INT NOT NULL,
    column_changed VARCHAR(50) NOT NULL,
    old_value TEXT,
    new_value TEXT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Function to handle any column changes
CREATE
OR REPLACE FUNCTION registrar_auditoria_geral() RETURNS TRIGGER AS $$
BEGIN -- Check each column for changes
    IF OLD .nome IS DISTINCT
FROM NEW .nome THEN
INSERT INTO Funcionario_Auditoria_Geral (
        funcionario_id,
        column_changed,
        old_value,
        new_value
    )
VALUES (OLD .id, 'nome', OLD .nome, NEW .nome);

END IF;

IF OLD .salario IS DISTINCT
FROM NEW .salario THEN
INSERT INTO Funcionario_Auditoria_Geral (
        funcionario_id,
        column_changed,
        old_value,
        new_value
    )
VALUES (
        OLD .id,
        'salario',
        OLD .salario::TEXT,
        NEW .salario::TEXT
    );

END IF;

IF OLD .dtcontratacao IS DISTINCT
FROM NEW .dtcontratacao THEN
INSERT INTO Funcionario_Auditoria_Geral (
        funcionario_id,
        column_changed,
        old_value,
        new_value
    )
VALUES (
        OLD .id,
        'dtcontratacao',
        OLD .dtcontratacao::TEXT,
        NEW .dtcontratacao::TEXT
    );

END IF;

RETURN NEW;

END;

$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE
OR REPLACE TRIGGER trg_funcionario_modificado AFTER
UPDATE ON Funcionario FOR EACH ROW EXECUTE FUNCTION registrar_auditoria_geral();

-- automatically update funcionario table to trigger general audit trigger
-- Script to automatically update funcionarios with 3 changes each
DO $$
DECLARE funcionario_record RECORD;

update_count INTEGER := 0;

BEGIN -- Loop through all employees in the funcionario table
    FOR funcionario_record IN
SELECT id,
    nome,
    salario,
    dtcontratacao
FROM Funcionario
ORDER BY id
LOOP -- First update: Increase salary by 10% and add " [Updated]" to name
UPDATE Funcionario
SET salario = salario * 1.10,
    nome = nome || ' [Updated]'
WHERE id = funcionario_record.id;

update_count := update_count + 1;

RAISE NOTICE 'Completed update % for employee %',
update_count,
funcionario_record.id;

-- Wait a moment to ensure timestamp changes
PERFORM pg_sleep(0.1);

-- Second update: Change name format and adjust contract date (+30 days)
UPDATE Funcionario
SET nome = REPLACE(nome, ' [Updated]', ' [Modified]'),
    dtcontratacao = dtcontratacao + INTERVAL '30 days'
WHERE id = funcionario_record.id;

update_count := update_count + 1;

RAISE NOTICE 'Completed update % for employee %',
update_count,
funcionario_record.id;

-- Wait a moment
PERFORM pg_sleep(0.1);

-- Third update: Final salary adjustment and name cleanup, revert contract date
UPDATE Funcionario
SET salario = salario * 0.95,
    -- Small decrease
    nome = REPLACE(nome, ' [Modified]', ' [Final]'),
    dtcontratacao = dtcontratacao - INTERVAL '15 days'
WHERE id = funcionario_record.id;

update_count := update_count + 1;

RAISE NOTICE 'Completed update % for employee %',
update_count,
funcionario_record.id;

RAISE NOTICE 'Completed all 3 updates for employee ID: %',
funcionario_record.id;

END
LOOP;

RAISE NOTICE 'Finished! Completed % total updates across all employees.',
update_count;

END $$;

-- Criação da tabela Produto
CREATE TABLE IF NOT EXISTS Produto (
    cod_prod INT PRIMARY KEY,
    descricao VARCHAR(50) UNIQUE,
    qtde_disponivel INT NOT NULL DEFAULT 0
);

-- Inserção de produtos
INSERT INTO Produto
VALUES (1, 'Basica', 10);

INSERT INTO Produto
VALUES (2, 'Dados', 5);

INSERT INTO Produto
VALUES (3, 'Verao', 15);

-- Criação da tabela RegistroVendas
CREATE TABLE IF NOT EXISTS RegistroVendas (
    cod_venda SERIAL PRIMARY KEY,
    cod_prod INT,
    qtde_vendida INT,
    FOREIGN KEY (cod_prod) REFERENCES Produto(cod_prod) ON
    DELETE CASCADE
);

-- Criação de um TRIGGER
CREATE
OR REPLACE FUNCTION verifica_estoque() RETURNS TRIGGER AS $$
DECLARE qted_atual INTEGER;

prod_desc VARCHAR(50);

BEGIN
SELECT qtde_disponivel,
    descricao INTO qted_atual,
    prod_desc
FROM Produto
WHERE cod_prod = NEW .cod_prod;

IF qted_atual < NEW .qtde_vendida THEN RAISE
EXCEPTION 'Quantidade indisponivel em estoque. Produto: % possui apenas % unidades disponiveis.',
    prod_desc,
    qted_atual;

ELSE
UPDATE Produto
SET qtde_disponivel = qtde_disponivel - NEW .qtde_vendida
WHERE cod_prod = NEW .cod_prod;

END IF;

RETURN NEW;

END;

$$ LANGUAGE plpgsql;

CREATE
OR replace TRIGGER trg_verifica_estoque BEFORE
INSERT ON RegistroVendas FOR EACH ROW EXECUTE FUNCTION verifica_estoque();

-- Tentativa de venda de 5 unidades de Basico (deve ser bem-sucedida, pois há 10 unidades disponíveis)
INSERT INTO RegistroVendas (cod_prod, qtde_vendida)
VALUES (1, 5);

-- Tentativa de venda de 6 unidades de Dados (deve ser bem-sucedida, pois há 5 unidades disponíveis e a quantidade vendida não excede o estoque)
INSERT INTO RegistroVendas (cod_prod, qtde_vendida)
VALUES (2, 5);

-- Tentativa de venda de 16 unidades de Versao (deve falhar, pois só há 15 unidades disponíveis)
INSERT INTO RegistroVendas (cod_prod, qtde_vendida)
VALUES (3, 16);