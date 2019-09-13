CREATE TABLE song_requests (
  id SERIAL PRIMARY KEY,
  hacker_id INTEGER NOT NULL,
  url VARCHAR (255) NOT NULL,
  played BOOL DEFAULT 'f',
  deleted_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL,
  FOREIGN KEY (hacker_id) REFERENCES hackers (id)
);
