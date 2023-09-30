create type tripulation_kind as enum (
    'command',
    'navigation',
    'machinery',
    'loading and unloading operation',
    'security',
    'communication',
    'medical care',
    'kitchen',
    'cleaning',
    'administration',
    'environmental protection'
)

CREATE TABLE IF NOT EXISTS crews (
    id serial,
    ship_id integer NOT NULL REFERENCES ships(id),
    name text NOT NULL,
    cpf char(11) NOT NULL,
    nationality char(3) NOT NULL,
    dbo date NOT NULL,
    gender char(1) NOT NULL,
    category tripulation_kind NOT NULL,
    PRIMARY KEY(id)
);
