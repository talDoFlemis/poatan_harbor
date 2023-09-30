CREATE TYPE employee_kind AS enum (
    'director',
    'security',
    'crane operator',
    'cargo operator',
    'stevedore',
    'cargo checker',
    'traffic controller',
    'pilot',
    'customs officer',
    'customer service agent',
    'human resources',
    'maintenance',
    'other'
);

CREATE TABLE IF NOT EXISTS employees (
    id serial,
    name text NOT NULL,
    email text NOT NULL,
    telephone text NOT NULL,
    dbo date NOT NULL,
    gender char(1) NOT NULL,
    cpf char(11) NOT NULL,
    kind employee_kind NOT NULL
);
