##########
# config.ru
#

require File.dirname(__FILE__) + '/server/server.rb'

run Synthia::Server
