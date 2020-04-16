require 'pg'
load 'lib/synthia.rb'
Synthia::init

db = PG.connect(
  :host => Synthia::Config['database']['host'],
  :port => Synthia::Config['database']['port'],
  :dbname => Synthia::Config['database']['name'],
  :user => Synthia::Config['database']['username'],
  :password => Synthia::Config['database']['password']
)

files = Dir.glob('db/sql/**/*.sql').sort_by {|f| File.mtime(f)}

files.each do |sql_file|
  sql = File.open(sql_file) {|file| file.read}
  db.exec sql
end
