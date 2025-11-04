DO $$
DECLARE random_client_id UUID;


BEGIN -- Get a random client ID
SELECT id INTO random_client_id
FROM clients
ORDER BY RANDOM()
LIMIT 1;


RAISE NOTICE 'Random client: %',
random_client_id;


CALL realizar_transacao('d', 'yellow', 50000, random_client_id);


END $$;