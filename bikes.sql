CREATE TABLE bikes (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES human(id)
);

CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER,

  FOREIGN KEY(house_id) REFERENCES human(id)
);

CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  houses (id, address)
VALUES
  (1, "3rd and Union"), (2, "7th ave and 9th");

INSERT INTO
  humans (id, fname, lname, house_id)
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
