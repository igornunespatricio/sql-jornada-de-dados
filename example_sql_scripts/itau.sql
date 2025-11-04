CREATE extension IF NOT EXISTS "uuid-ossp";


CREATE TABLE IF NOT EXISTS clients (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL,
    CHECK (saldo >= - limite),
    CHECK (limite > 0)
);


CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY NOT NULL,
    tipo CHAR(1) NOT NULL,
    descricao VARCHAR(10) NOT NULL,
    valor INTEGER NOT NULL,
    cliente_id UUID NOT NULL,
    realizada_em TIMESTAMP NOT NULL DEFAULT NOW()
);


INSERT INTO clients (limite, saldo)
VALUES (100000, 0),
    (80000, 0),
    (1000000, 0),
    (10000000, 0),
    (500000, 0);


-- stored procedure to validate and perform transaction
CREATE
OR REPLACE PROCEDURE realizar_transacao(
    IN p_tipo CHAR(1),
    IN p_descricao VARCHAR(10),
    IN p_valor INTEGER,
    IN p_cliente_id UUID
) LANGUAGE plpgsql AS $$
DECLARE saldo_atual INTEGER;


limite_cliente INTEGER;


saldo_apos_transacao INTEGER;


BEGIN
SELECT saldo,
    limite INTO saldo_atual,
    limite_cliente
FROM clients
WHERE id = p_cliente_id;


RAISE NOTICE 'Saldo atual do cliente: %',
saldo_atual;


RAISE NOTICE 'Limite atual do cliente: %',
limite_cliente;


IF p_tipo = 'd'
AND saldo_atual - p_valor < - limite_cliente THEN RAISE
EXCEPTION 'Limite inferior ao necessario da transacao';


END IF;


UPDATE clients
SET saldo = saldo + CASE
        WHEN p_tipo = 'd' THEN - p_valor
        ELSE p_valor
    END
WHERE id = p_cliente_id;


INSERT INTO transactions (tipo, descricao, valor, cliente_id)
VALUES (p_tipo, p_descricao, p_valor, p_cliente_id);


SELECT saldo INTO saldo_apos_transacao
FROM clients
WHERE id = p_cliente_id;


RAISE NOTICE 'Saldo cliente apos transacao: %',
saldo_apos_transacao;


END;


$$;


-- execute random transactions per client
DO $$
DECLARE item RECORD;


counter_ids INTEGER := 0;


trans_type CHAR(1);


descriptions TEXT [ ] := ARRAY [ 'food',
'transport',
'shopping',
'bill',
'gift',
'salary',
'transfer' ];


random_desc TEXT;


random_value INTEGER;


BEGIN FOR item IN
SELECT id,
    saldo
FROM clients
LOOP counter_ids := counter_ids + 1;


RAISE NOTICE 'Client: %, %',
item.id,
item.saldo;


-- Generate 8-27 random transactions per client
FOR i IN 1 ..floor(random() * 20 + 8)
LOOP -- Random transaction type (70% debit, 30% credit)
    IF random() < 0.7 THEN trans_type := 'd';


ELSE trans_type := 'c';


END IF;


-- Random description and value
random_desc := descriptions [ floor(random() * array_length(descriptions, 1) + 1) ];


random_value := floor(random() * 900 + 100);


-- Values between 100-1000
RAISE NOTICE '  Transaction: %, %, %',
trans_type,
random_desc,
random_value;


-- Execute the transaction
CALL realizar_transacao(trans_type, random_desc, random_value, item.id);


END
LOOP;


EXIT
WHEN counter_ids = 10;


END
LOOP;


END $$;


-- create stored procedure to extract last 10 transactions
CREATE
OR replace PROCEDURE get_extract(client_id UUID) LANGUAGE plpgsql AS $$
DECLARE balance INTEGER;


last_10_transactions RECORD;


counter_transactions INTEGER := 0;


BEGIN
SELECT saldo INTO balance
FROM clients
WHERE id = client_id;


RAISE notice 'Actual balance for client %: %',
client_id,
balance;


RAISE notice 'Last 10 transactions';


FOR last_10_transactions IN
SELECT id,
    tipo,
    descricao,
    valor,
    cliente_id,
    realizada_em
FROM transactions
WHERE cliente_id = client_id
ORDER BY realizada_em DESC
LIMIT 10
LOOP counter_transactions := counter_transactions + 1;


RAISE NOTICE 'id: %, tipo: %, descricao: %, valor: %, cliente_id: %, realizada_em: %',
last_10_transactions.id,
last_10_transactions.tipo,
last_10_transactions.descricao,
last_10_transactions.valor,
last_10_transactions.cliente_id,
last_10_transactions.realizada_em;


EXIT
WHEN counter_transactions = 10;


END
LOOP;


END;


$$;