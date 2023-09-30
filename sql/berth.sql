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

CREATE TABLE IF NOT EXISTS bl (
    id serial,
    berth_id string NOT NULL REFERENCES berths (id),
    ship_id string NOT NULL REFERENCES ships (id),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    issued_at timestamp with time zone NOT NULL,
    PRIMARY KEY (id, berth_id, ship_id)
);
