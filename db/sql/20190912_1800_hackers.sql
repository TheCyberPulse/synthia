CREATE TABLE hackers (
  id SERIAL PRIMARY KEY,
  alias VARCHAR (64) UNIQUE NOT NULL,
  twitch_user_id VARCHAR (255) NOT NULL,
  deleted_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL
);
