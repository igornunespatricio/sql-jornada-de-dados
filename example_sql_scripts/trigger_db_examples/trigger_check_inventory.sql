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