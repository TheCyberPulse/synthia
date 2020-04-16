CREATE TABLE cred (
  id SERIAL PRIMARY KEY,
  hacker_id INTEGER NOT NULL,
  amount INTEGER,
  deleted_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL,
  FOREIGN KEY (hacker_id) REFERENCES hackers (id)
);
