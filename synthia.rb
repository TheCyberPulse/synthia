require 'rubygems'
require 'summer'
load 'lib/synthia.rb'
load 'app/controller.rb'
Synthia::init

class SynthiaPulse < Summer::Connection

  def channel_message(sender, channel, message)
    puts "#{sender[:nick]} [#{channel}]: #{message}"
    response_message = parse_command message
    response("PRIVMSG #{Synthia::Config[:channel]} :#{response_message}") unless response_message.to_s == ''
  end

  def did_start_up
    response('CAP REQ :twitch.tv/membership')
    puts Synthia::Config.settings
  end

  private

  def parse_command(message)
    command_prefix = Synthia::Config[:command_prefix]
    return unless message.to_s.downcase.include?(command_prefix)
    command = message.to_s.split(' ')[0].to_s.gsub(command_prefix, '')
    return if command == ''
    Synthia::Controller.new.call command
  end
end

SynthiaPulse.new('irc.chat.twitch.tv', 6667)
