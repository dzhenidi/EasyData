CREATE TABLE bikes (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES biker(id)
);

CREATE TABLE bikers (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  team_id INTEGER,

  FOREIGN KEY(team_id) REFERENCES biker(id)
);

CREATE TABLE teams (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  teams (id, address)
VALUES
  (1, "Gowanus"), (2, "Astoria");

INSERT INTO
  bikers (id, fname, lname, team_id)
VALUES
  (1, "Frank", "W", 1),
  (2, "Jill", "R", 1),
  (3, "Tony", "F", 2),
  (4, "Bikeless", "Human", NULL);

INSERT INTO
  bikes (id, name, owner_id)
VALUES
  (1, "Jamis Aurora", 1),
  (2, "Surley LongHaulTrucker", 2),
  (3, "Raleigh Talus", 3),
  (4, "Motobecane Mirage", 3),
  (5, "road bike", NULL);
