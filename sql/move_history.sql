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
