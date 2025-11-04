-- delete rows from database, if not using where, than delete alll rows, be carefull
DELETE FROM
    clients
WHERE
    id = 1 -- needs adding a uuid from the table