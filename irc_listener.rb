require 'cinch'
require 'rest-client'
require 'json'
require 'yaml'

IRC_CONFIG = YAML.load(File.read("./config/irc_config.yaml"))
SHARED_CONFIG = YAML.load(File.read("./config/shared_config.yaml"))

bot = Cinch::Bot.new do
  configure do |c|
    c.nick = IRC_CONFIG[:nick]
    c.realname = IRC_CONFIG[:realname]
    c.server = IRC_CONFIG[:server]
    c.password = IRC_CONFIG[:password]
    c.channels = IRC_CONFIG[:channels]
    c.default_logger_level = :log
  end

  on :connect do |m|
    m.bot.irc.send("CAP REQ :twitch.tv/membership")
  end

  on :message do |m|
    if m.message.start_with? '!'
      # Create an empty variable to store the redirect URL's response,
      # split the message into parts for easier processing,
      # and create a hash with the appropriate POST parameters

      new_response = nil
      message_parts = m.message.split(' ')
      post_params = {:message_parts => message_parts, :user => m.user.nick}.to_json

      # We make an initial request to find the appropriate command endpoint, then follow through to the new URL
      RestClient.post("#{SHARED_CONFIG[:root_url]}/process_command", post_params) do |response, request, result, &block|
        if [301, 302, 307].include? response.code
          redirect_url = response.headers[:location]
          puts "REDIRECT_URL", redirect_url
          new_response = RestClient.post(redirect_url, post_params)
        else
          response.return!(request, result, &block)
        end
      end

      # The bot will respond with the message returned from the API
      message_response = JSON.parse(new_response.body)
      m.reply "#{message_response['message']}"
    end
  end
end

bot.loggers.level = :log
bot.start
