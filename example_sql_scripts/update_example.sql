UPDATE
    clients
SET
    saldo = saldo + CASE
        WHEN 'd' = 'd' THEN -80000
        ELSE 80000
    END
WHERE
    id = '29e1fb18-3e74-4623-b7d6-0946187a66fe';