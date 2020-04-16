CREATE TABLE custom_commands (
  id SERIAL PRIMARY KEY,
  name VARCHAR (50) NOT NULL,
  aliases VARCHAR (255),
  response_content TEXT,
  deleted_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL
);
