import { faker } from "@faker-js/faker";
import { Pool } from "pg";

const pool = new Pool({
  user: "admin",
  host: "localhost",
  database: "poatan",
  password: "senha",
  port: 5432,
});
const client = await pool.connect();
await client.query("BEGIN");

const ship_status = [
  "anchored",
  "moored",
  "in_transit",
  "waiting_in_queue",
  "under_load",
  "under_discharge",
  "in_quarantine",
  "under_repair_maintenance",
];

const employeed_kind = [
  "director",
  "security",
  "crane operator",
  "cargo operator",
  "stevedore",
  "cargo checker",
  "traffic controller",
  "pilot",
  "customs officer",
  "customer service agent",
  "human resources",
  "maintenance",
  "other",
];

const resource_kind = [
  "standard container",
  "tank container",
  "open top container",
  "refrigerated container",
  "car carrier container",
  "flat rack container",
  "flexible container",
  "forklift",
  "tractor",
  "truck",
  "crane",
  "fueling facility",
  "repair facility",
  "cleaning facility",
  "other",
];

const resorce_status = [
  "available",
  "not_available",
  "in_use",
  "in_maintenance",
];

const crew_kind = [
  "command",
  "navigation",
  "machinery",
  "loading and unloading operation",
  "security",
  "communication",
  "medical care",
  "kitchen",
  "cleaning",
  "administration",
  "environmental protection",
];

const operation_type = [
  "loading",
  "unloading",
  "maintenance",
  "storage",
  "fueling",
  "cargo transfer",
  "other",
];

console.log("Starting");

console.log("Inserting Berths");
let berthQuery = "INSERT INTO berths (id) VALUES ";
["A", "B", "C", "D", "E", "F", "G", "H"].map((letter) => {
  for (let i = 1; i <= 5; i++) {
    berthQuery += `('${letter}${i}'),`;
  }
});
berthQuery = berthQuery.slice(0, -1) + ";";
await client.query(berthQuery);

console.log("Inserting Companies");
const numberOfCompanies = 15;
let companyQuery = "INSERT INTO companies (name) VALUES ";
for (let i = 0; i < numberOfCompanies; i++) {
  companyQuery += `($$${faker.company.name()}$$),`;
}
companyQuery = companyQuery.slice(0, -1) + ";";
await client.query(companyQuery);

console.log("Inserting Ships");
const numberOfShipsWithSelfLoad = 50;
let shipQuery =
  "INSERT INTO ships (name, imo, flag, company_id, kind, status, geo_position, length, width, height, draft, weight) VALUES ";
for (let i = 0; i < numberOfShipsWithSelfLoad; i++) {
  //name, imo, flag
  const imo = "IMO" + faker.number.int({ min: 1000000, max: 9999999 });
  shipQuery += `($$${faker.person.lastName()}$$, $$${imo}$$, $$${faker.location.countryCode(
    "alpha-3",
  )}$$,`;
  //company_id, kind, status
  const status =
    ship_status[faker.number.int({ min: 1, max: ship_status.length - 1 })];
  shipQuery += `${faker.number.int({
    min: 1,
    max: numberOfCompanies,
  })}, $$${faker.science.chemicalElement().name}$$, $$${status}$$,`;
  //geo_position
  const latitude = faker.location.latitude();
  const longitude = faker.location.longitude();
  shipQuery += `POINT(${latitude}, ${longitude}),`;
  //lenght, width, height, draft, weight
  shipQuery += `${faker.number.int({
    min: 1,
    max: 10000,
  })}, ${faker.number.int({
    min: 1,
    max: 10000,
  })}, ${faker.number.int({
    min: 1,
    max: 10000,
  })}, ${faker.number.int({
    min: 1,
    max: 10000,
  })}, ${faker.number.int({ min: 1, max: 10000 })}),`;
}
shipQuery = shipQuery.slice(0, -1) + ";";
await client.query(shipQuery);

console.log("Inserting Employees");
const numberOfEmployees = 100;
let employeeQuery =
  "INSERT INTO employees (name, email, telephone, dbo, gender, cpf, kind) VALUES ";
for (let i = 0; i < numberOfEmployees; i++) {
  employeeQuery += `($$${faker.person.firstName()}$$, $$${faker.internet.email()}$$, $$${faker.phone.number()}$$, $$${faker.date.past().toLocaleDateString()}$$, $$${faker.string.fromCharacters(
    ["M", "F"],
  )}$$, $$${faker.number.int(1000000)}$$, $$${
    employeed_kind[faker.number.int({ min: 1, max: employeed_kind.length }) - 1]
  }$$),`;
}
employeeQuery = employeeQuery.slice(0, -1) + ";";
await client.query(employeeQuery);

console.log("Inserting Resources");
const numberOfResources = 300;
let portuaryResourceQuery =
  "INSERT INTO portuary_resources (name, kind, status) VALUES ";
for (let i = 0; i < numberOfResources; i++) {
  portuaryResourceQuery += `($$${faker.commerce.productName()}$$, $$${
    resource_kind[faker.number.int({ min: 1, max: resource_kind.length }) - 1]
  }$$, $$${
    resorce_status[faker.number.int({ min: 1, max: resorce_status.length }) - 1]
  }$$),`;
}
portuaryResourceQuery = portuaryResourceQuery.slice(0, -1) + ";";
await client.query(portuaryResourceQuery);

console.log("Inserting Crews");
const minCrewSize = 30;
const maxCrewSize = 50;
let crewQuery =
  "INSERT INTO crews (ship_id, name, cpf, nationality, dbo, gender, category) VALUES ";
for (let i = 0; i < numberOfShipsWithSelfLoad; i++) {
  const crewSize = faker.number.int({ min: minCrewSize, max: maxCrewSize });
  for (let j = 0; j < crewSize; j++) {
    crewQuery += `(${
      i + 1
    }, $$${faker.person.lastName()}$$, $$${faker.number.int({
      min: 1000000,
      max: 9999999,
    })}$$, $$${faker.location.countryCode("alpha-3")}$$, $$${faker.date
      .past()
      .toLocaleDateString()}$$, $$${faker.string.fromCharacters([
      "M",
      "F",
    ])}$$, $$${
      crew_kind[faker.number.int({ min: 1, max: crew_kind.length }) - 1]
    }$$),`;
  }
}
crewQuery = crewQuery.slice(0, -1) + ";";
await client.query(crewQuery);

console.log("Inserting Commanders");
const commandersId = await client
  .query(
    "SELECT DISTINCT ON (ship_id) id, ship_id FROM crews ORDER BY ship_id, id;",
  )
  .then((res) => res.rows);

let commanderQuery = "INSERT INTO commanders (crew_id, ship_id) VALUES ";
commandersId.map((commander) => {
  commanderQuery += `(${commander.id}, ${commander.ship_id}),`;
});
commanderQuery = commanderQuery.slice(0, -1) + ";";
await client.query(commanderQuery);

console.log("Inserting Teams");
const minNumberOfTeams = 3;
const maxNumberOfTeams = 10;
let teamQuery = "INSERT INTO teams (name, ship_id) VALUES ";
for (let i = 0; i < numberOfShipsWithSelfLoad; i++) {
  const numberOfTeams = faker.number.int({
    min: minNumberOfTeams,
    max: maxNumberOfTeams,
  });
  for (let j = 0; j < numberOfTeams; j++) {
    teamQuery += `($$${faker.commerce.department()}$$, ${i + 1}),`;
  }
}
teamQuery = teamQuery.slice(0, -1) + ";";
await client.query(teamQuery);

console.log("Inserting Team Members");
const teamMembers = `
INSERT INTO teams_crews (crew_id, team_id)
SELECT
    c.id AS crew_id,
    t.id AS team_id
FROM
    crews c
JOIN
    teams t ON c.ship_id = t.ship_id;
`;
await client.query(teamMembers);

console.log("Insert Move History");
const numberOfMoverPerShip = 10;
let moveHistoryQuery =
  "INSERT INTO move_history (ship_id, team_id, operation) VALUES ";
for (let i = 0; i < numberOfShipsWithSelfLoad; i++) {
  const shipTeam = await client
    .query("SELECT id, ship_id FROM teams WHERE ship_id = $1 LIMIT 1", [i + 1])
    .then((res) => res.rows);
  for (let j = 0; j < numberOfMoverPerShip; j++) {
    const team = shipTeam[0];
    moveHistoryQuery += `(${i + 1}, ${team.id}, $$${
      operation_type[
        faker.number.int({ min: 1, max: operation_type.length }) - 1
      ]
    }$$),`;
  }
}
moveHistoryQuery = moveHistoryQuery.slice(0, -1) + ";";
await client.query(moveHistoryQuery);

await client.query("COMMIT");
console.log("Shutdown");
client.release();
