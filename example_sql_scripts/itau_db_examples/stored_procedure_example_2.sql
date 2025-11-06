CREATE
OR replace PROCEDURE get_extract(client_id UUID, number_transactions INTEGER) LANGUAGE plpgsql AS $$
DECLARE balance INTEGER;


last_n_transactions RECORD;


counter_transactions INTEGER := 0;


BEGIN
SELECT saldo INTO balance
FROM clients
WHERE id = client_id;


RAISE notice 'Actual balance for client %: %',
client_id,
balance;


RAISE notice 'Last % transactions',
number_transactions;


FOR last_n_transactions IN
SELECT id,
    tipo,
    descricao,
    valor,
    cliente_id,
    realizada_em
FROM transactions
WHERE cliente_id = client_id
ORDER BY realizada_em DESC
LIMIT number_transactions
LOOP counter_transactions := counter_transactions + 1;


RAISE NOTICE 'id: %, tipo: %, descricao: %, valor: %, cliente_id: %, realizada_em: %',
last_n_transactions.id,
last_n_transactions.tipo,
last_n_transactions.descricao,
last_n_transactions.valor,
last_n_transactions.cliente_id,
last_n_transactions.realizada_em;


EXIT
WHEN counter_transactions = number_transactions;


END
LOOP;


END;


$$;