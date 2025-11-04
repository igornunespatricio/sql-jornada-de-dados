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