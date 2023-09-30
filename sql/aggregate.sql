CREATE TYPE berth_status AS enum (
    'available',
    'occupied',
    'maintenance'
);

CREATE TABLE IF NOT EXISTS berths (
    id text PRIMARY KEY,
    status berth_status NOT NULL DEFAULT 'available',
    created_at timestamp with time zone NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS companies (
    id serial PRIMARY KEY,
    name text NOT NULL
);

CREATE TYPE ship_status AS enum (
    'moored',
    'anchored',
    'in_transit',
    'waiting_in_queue',
    'under_load',
    'under_discharge',
    'in_quarantine',
    'under_repair_maintenance'
);

CREATE TABLE IF NOT EXISTS ships (
    id serial PRIMARY KEY,
    name text NOT NULL,
    imo char(10) NOT NULL,
    flag char(3) NOT NULL,
    company_id integer NOT NULL REFERENCES companies (id),
    company_load_id integer REFERENCES companies (id),
    kind text NOT NULL,
    geo_position point NOT NULL,
    status ship_status NOT NULL,
    length integer NOT NULL,
    width integer NOT NULL,
    height integer NOT NULL,
    draft integer NOT NULL,
    weight integer NOT NULL,
    inserted_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TYPE crew_kind AS enum (
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
);

CREATE TABLE IF NOT EXISTS crews (
    id serial,
    ship_id integer NOT NULL REFERENCES ships (id),
    name text NOT NULL,
    cpf char(11) NOT NULL,
    nationality char(3) NOT NULL,
    dbo date NOT NULL,
    gender char(1) NOT NULL,
    category crew_kind NOT NULL,
    PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS commanders (
    crew_id integer NOT NULL REFERENCES crews (id),
    ship_id integer NOT NULL REFERENCES ships (id),
    UNIQUE (ship_id),
    PRIMARY KEY (crew_id, ship_id)
);

CREATE TABLE IF NOT EXISTS bl (
    id serial,
    berth_id text NOT NULL REFERENCES berths (id),
    ship_id integer NOT NULL REFERENCES ships (id),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    issued_at timestamp with time zone NOT NULL,
    PRIMARY KEY (id, berth_id, ship_id)
);

CREATE TABLE IF NOT EXISTS teams (
    id serial,
    ship_id integer NOT NULL REFERENCES ships (id),
    name text NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS teams_crews (
    team_id integer NOT NULL REFERENCES teams (id),
    crew_id integer NOT NULL REFERENCES crews (id),
    PRIMARY KEY (team_id, crew_id)
);

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

CREATE TYPE resource_kind AS ENUM (
    'standard container',
    'tank container',
    'open top container',
    'refrigerated container',
    'car carrier container',
    'flat rack container',
    'flexible container',
    'forklift',
    'tractor',
    'truck',
    'crane',
    'fueling facility',
    'repair facility',
    'cleaning facility',
    'other'
);

CREATE TYPE resource_status AS enum (
    'available',
    'not_available',
    'in_use',
    'in_maintenance'
);

CREATE TABLE IF NOT EXISTS portuary_resources (
    id serial,
    name text NOT NULL,
    kind resource_kind NOT NULL,
    status resource_status NOT NULL,
    inserted_at timestamp with time zone NOT NULL DEFAULT now(),
    PRIMARY KEY (id)
);

CREATE TYPE operation_type AS ENUM (
    'loading',
    'unloading',
    'maintenance',
    'storage',
    'fueling',
    'cargo transfer',
    'other'
);

CREATE TABLE IF NOT EXISTS move_history (
    id serial,
    ship_id integer NOT NULL REFERENCES ships (id),
    team_id integer NOT NULL REFERENCES teams (id),
    operation operation_type NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS move_history_portuary_resources (
    move_history_id integer NOT NULL REFERENCES move_history (id),
    resource_id integer NOT NULL REFERENCES portuary_resources (id),
    moved_at timestamp with time zone NOT NULL DEFAULT now(),
    PRIMARY KEY (move_history_id, resource_id)
);

CREATE TABLE IF NOT EXISTS move_history_human_resources (
    move_history_id integer NOT NULL REFERENCES move_history (id),
    crew_id integer NOT NULL REFERENCES crews (id),
    moved_at timestamp with time zone NOT NULL DEFAULT now(),
    PRIMARY KEY (move_history_id, crew_id)
);
