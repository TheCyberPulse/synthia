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
Dir.glob(
  File.dirname(File.absolute_path(__FILE__)) + '/app/models/**/*',
  &method(:load)
)

class SynthiaPulse < Summer::Connection

  def channel_message(sender, channel, message)
    puts "#{sender[:nick]} [#{channel}]: #{message}"
    hacker = Synthia::Model::Hacker.find_or_create sender[:nick]
    response_message = parse_and_execute_command(hacker, parse_message(message))
    return if response_message.to_s == ''
    response("PRIVMSG #{Synthia::Config[:channel]} :#{response_message}")
  end

  def did_start_up
    response('CAP REQ :twitch.tv/membership')
    puts Synthia::Config.settings
  end

  private

  def parse_and_execute_command(hacker, parsed_message)
    command = sanitize_and_unwrap(parsed_message[:command_section])
    return if command == ''
    Synthia::Controller.new.call hacker, command, parsed_message[:input]
  end

  # Takes message and separates command part from the rest, e.g.
  # {
  #   :command_section => '!pulsesr',
  #   :input => ['https://youtu.be/?v=1234567', 'a', 'cool', 'song']
  # }
  def parse_message(message)
    message_array = message.to_s.split(' ')
    # Due to the call to `shift`,
    # the first element of the array is removed.
    {
      :command_section => message_array.shift,
      :input => message_array
    }
  end

  def sanitize_and_unwrap(command_name)
    command_prefix = Synthia::Config[:command_prefix]
    return unless command_name.to_s.downcase.include?(command_prefix)
    command_name.to_s.gsub(command_prefix, '')
  end
end

SynthiaPulse.new('irc.chat.twitch.tv', 6667)
