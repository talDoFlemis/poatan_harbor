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
    commander_id integer NOT NULL REFERENCES commanders (id),
    flag char(3) NOT NULL,
    company_id integer NOT NULL REFERENCES companies (id),
    company_load_id integer REFERENCES companies (id),
    kind TEXT NOT NULL,
    geo_position point NOT NULL,
    status ship_status NOT NULL,
    length integer NOT NULL,
    width integer NOT NULL,
    height integer NOT NULL,
    draft integer NOT NULL,
    weight integer NOT NULL,
    inserted_at timestamp with time zone NOT NULL DEFAULT now()
);
