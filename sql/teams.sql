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
