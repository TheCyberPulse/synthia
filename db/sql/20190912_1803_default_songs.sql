CREATE TABLE default_songs (
  id SERIAL PRIMARY KEY,
  hacker_id INTEGER NOT NULL,
  url VARCHAR (255) NOT NULL,
  last_played_at TIMESTAMPTZ,
  deleted_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL,
  FOREIGN KEY (hacker_id) REFERENCES hackers (id)
);
