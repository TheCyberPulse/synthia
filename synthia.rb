require 'rubygems'
require 'summer'
require 'sequel'
load 'lib/synthia.rb'
load 'app/controller.rb'
Synthia::init

# Connect to database
DB = Sequel.postgres(
  Synthia::Config['database']['name'],
  :user => Synthia::Config['database']['username'],
  :password => Synthia::Config['database']['password'],
  :host => Synthia::Config['database']['host'],
  :port => Synthia::Config['database']['port']
)
# Load models
Dir.glob(File.dirname(File.absolute_path(__FILE__)) + '/app/models/**/*', &method(:load))

class SynthiaPulse < Summer::Connection

  def channel_message(sender, channel, message)
    puts "#{sender[:nick]} [#{channel}]: #{message}"

    hacker = Hacker.find_or_create sender[:nick]
    p '*************************'
    p hacker[:alias]
    p '*************************'

    response_message = parse_command message
    response("PRIVMSG #{Synthia::Config[:channel]} :#{response_message}") unless response_message.to_s == ''
  end

  def did_start_up
    response('CAP REQ :twitch.tv/membership')
    puts Synthia::Config.settings
  end

  private

  def parse_command(message)
    command = sanitize_and_unwrap(message.to_s.split(' ')[0])
    return if command == ''
    Synthia::Controller.new.call command
  end

  def sanitize_and_unwrap(command_name)
    command_prefix = Synthia::Config[:command_prefix]
    return unless command_name.to_s.downcase.include?(command_prefix)
    command_name.to_s.gsub(command_prefix, '')
  end
end

SynthiaPulse.new('irc.chat.twitch.tv', 6667)
