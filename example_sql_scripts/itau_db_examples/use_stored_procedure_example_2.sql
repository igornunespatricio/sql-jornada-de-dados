DO $$
DECLARE client_id uuid;


BEGIN
SELECT cliente_id INTO client_id
FROM transactions
GROUP BY cliente_id
ORDER BY COUNT(*) DESC
LIMIT 1;


RAISE NOTICE 'Client with most transactions: %',
client_id;


CALL get_extract(client_id, 20);


END $$;