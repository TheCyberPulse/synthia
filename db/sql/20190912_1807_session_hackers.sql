CREATE TABLE session_hackers (
  id SERIAL PRIMARY KEY,
  session_id INTEGER NOT NULL,
  hacker_id INTEGER NOT NULL,
  deleted_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL,
  FOREIGN KEY (session_id) REFERENCES sessions (id),
  FOREIGN KEY (hacker_id) REFERENCES hackers (id)
);
