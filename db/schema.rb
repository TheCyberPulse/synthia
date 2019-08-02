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

DB.create_table :hackers do
  primary_key :id
  String :alias
  String :twitch_user_id
  DateTime :deleted_at
  DateTime :created_at
  DateTime :updated_at
  index :twitch_user_id
  index :alias
end

DB.create_table :song_requests do
  primary_key :id
  foreign_key :hacker_id, :hackers
  TrueClass :played, :default => false
  String :url
  DateTime :deleted_at
  DateTime :created_at
  DateTime :updated_at
end
