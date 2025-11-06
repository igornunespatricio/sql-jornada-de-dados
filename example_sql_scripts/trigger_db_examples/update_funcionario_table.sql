-- Script to automatically update funcionarios with 3 changes each
DO $$
DECLARE funcionario_record RECORD;

update_count INTEGER := 0;

BEGIN -- Loop through all employees in the funcionario table
    FOR funcionario_record IN
SELECT id,
    nome,
    salario,
    dtcontratacao
FROM Funcionario
ORDER BY id
LOOP -- First update: Increase salary by 10% and add " [Updated]" to name
UPDATE Funcionario
SET salario = salario * 1.10,
    nome = nome || ' [Updated]'
WHERE id = funcionario_record.id;

update_count := update_count + 1;

RAISE NOTICE 'Completed update % for employee %',
update_count,
funcionario_record.id;

-- Wait a moment to ensure timestamp changes
PERFORM pg_sleep(0.1);

-- Second update: Change name format and adjust contract date (+30 days)
UPDATE Funcionario
SET nome = REPLACE(nome, ' [Updated]', ' [Modified]'),
    dtcontratacao = dtcontratacao + INTERVAL '30 days'
WHERE id = funcionario_record.id;

update_count := update_count + 1;

RAISE NOTICE 'Completed update % for employee %',
update_count,
funcionario_record.id;

-- Wait a moment
PERFORM pg_sleep(0.1);

-- Third update: Final salary adjustment and name cleanup, revert contract date
UPDATE Funcionario
SET salario = salario * 0.95,
    -- Small decrease
    nome = REPLACE(nome, ' [Modified]', ' [Final]'),
    dtcontratacao = dtcontratacao - INTERVAL '15 days'
WHERE id = funcionario_record.id;

update_count := update_count + 1;

RAISE NOTICE 'Completed update % for employee %',
update_count,
funcionario_record.id;

RAISE NOTICE 'Completed all 3 updates for employee ID: %',
funcionario_record.id;

END
LOOP;

RAISE NOTICE 'Finished! Completed % total updates across all employees.',
update_count;

END $$;