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