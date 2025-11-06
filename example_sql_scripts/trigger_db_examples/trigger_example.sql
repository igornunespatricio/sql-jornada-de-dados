-- Criação do Trigger para auditoria de alterações de salário
CREATE
OR REPLACE FUNCTION registrar_auditoria_salario() RETURNS TRIGGER AS $$
BEGIN
INSERT INTO Funcionario_Auditoria (id, salario_antigo, novo_salario)
VALUES (OLD .id, OLD .salario, NEW .salario);


RETURN NEW;


END;


$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_salario_modificado AFTER
UPDATE OF salario ON Funcionario FOR EACH ROW EXECUTE FUNCTION registrar_auditoria_salario();