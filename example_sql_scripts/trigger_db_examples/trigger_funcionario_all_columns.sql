-- Create audit table with column tracking
CREATE TABLE Funcionario_Auditoria_Geral (
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
CREATE TRIGGER trg_funcionario_modificado AFTER
UPDATE ON Funcionario FOR EACH ROW EXECUTE FUNCTION registrar_auditoria_geral();