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


INSERT INTO
    clients (limite, saldo)
VALUES
    (100000, 0),
    (80000, 0),
    (1000000, 0),
    (10000000, 0),
    (500000, 0);