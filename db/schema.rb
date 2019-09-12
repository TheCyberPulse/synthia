require 'sequel'
load 'lib/synthia.rb'
Synthia::init

# %w'String Integer Fixnum Float Numeric BigDecimal Date DateTime Time File TrueClass FalseClass'

DB = Sequel.postgres(
  Synthia::Config['database']['name'],
  :user => Synthia::Config['database']['username'],
  :password => Synthia::Config['database']['password'],
  :host => Synthia::Config['database']['host'],
  :port => Synthia::Config['database']['port']
)

unless DB.table_exists?(:hackers)
  DB.create_table :hackers do
    primary_key :id
    String :alias
    String :twitch_user_id
    DateTime :deleted_at
    DateTime :created_at
    DateTime :updated_at
    index :deleted_at
    index :twitch_user_id
    index :alias
  end
end

unless DB.table_exists?(:song_requests)
  DB.create_table :song_requests do
    primary_key :id
    foreign_key :hacker_id, :hackers
    TrueClass :played, :default => false
    String :url
    DateTime :deleted_at
    DateTime :created_at
    DateTime :updated_at
    index :deleted_at
    index :hacker_id
  end
end

unless DB.table_exists?(:default_songs)
  DB.create_table :default_songs do
    primary_key :id
    foreign_key :hacker_id, :hackers
    String :url
    DateTime :last_played_at
    DateTime :deleted_at
    DateTime :created_at
    DateTime :updated_at
    index :deleted_at
    index :hacker_id
    index :last_played_at
  end
end

unless DB.table_exists?(:custom_commands)
  DB.create_table :custom_commands do
    primary_key :id
    String :name
    String :aliases
    String :response_content
    DateTime :deleted_at
    DateTime :created_at
    DateTime :updated_at
    index :deleted_at
  end
end

unless DB.table_exists?(:creds)
  DB.create_table :creds do
    primary_key :id
    foreign_key :hacker_id, :hackers
    Integer :amount
    DateTime :deleted_at
    DateTime :created_at
    DateTime :updated_at
    index :deleted_at
    index :hacker_id
  end
end

unless DB.table_exists?(:sessions)
  DB.create_table :sessions do
    primary_key :id
    String :status
    DateTime :deleted_at
    DateTime :created_at
    DateTime :updated_at
    index :deleted_at
  end
end

unless DB.table_exists?(:session_hackers)
  DB.create_table :session_hackers do
    primary_key :id
    foreign_key :session_id
    foreign_key :hacker_id
    DateTime :deleted_at
    DateTime :created_at
    DateTime :updated_at
    index :deleted_at
    index :hacker_id
    index :session_id
  end
end
