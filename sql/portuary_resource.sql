CREATE TYPE resource_type AS ENUM (
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
    'in_maintenance',
);

CREATE TABLE IF NOT EXISTS portuary_resources (
    id serial,
    name text NOT NULL,
    type resource_type NOT NULL,
    status resource_status NOT NULL,
    inserted_at timestamp with time zone NOT NULL DEFAULT now(),
    PRIMARY KEY (id)
);
