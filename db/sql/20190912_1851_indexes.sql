-- INDEXES FOR hackers TABLE
CREATE UNIQUE INDEX idx_alias ON hackers (alias);
CREATE INDEX idx_twitch_user_id ON hackers (twitch_user_id);
CREATE INDEX idx_hackers_deleted_at ON hackers (deleted_at);

-- INDEXES FOR song_requests TABLE
CREATE INDEX idx_song_requests_deleted_at ON song_requests (deleted_at);

-- INDEXES FOR default_songs TABLE
CREATE INDEX idx_last_played_at ON default_songs (last_played_at);
CREATE INDEX idx_default_songs_deleted_at ON default_songs (deleted_at);

-- INDEXES FOR custom_commands TABLE
CREATE UNIQUE INDEX idx_name ON custom_commands (name);
CREATE INDEX idx_custom_commands_aliases ON custom_commands (aliases);
CREATE INDEX idx_custom_commands_deleted_at ON custom_commands (deleted_at);

-- INDEXES FOR cred TABLE
CREATE INDEX idx_cred_deleted_at ON cred (deleted_at);

-- INDEXES FOR sessions TABLE
CREATE INDEX idx_sessions_deleted_at ON sessions (deleted_at);

-- INDEXES FOR session_hackers TABLE
CREATE INDEX idx_session_hackers_deleted_at ON session_hackers (deleted_at);
