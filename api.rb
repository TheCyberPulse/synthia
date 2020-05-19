require 'rest-client'
require 'sinatra'
require 'json'
require 'yaml'

SHARED_CONFIG = YAML.load(File.read("./config/shared_config.yaml"))

$song_request_queue = []

def json_params(request_data)
  begin
    JSON.parse(request_data)
  rescue
    halt 400, {:message => 'Invalid JSON'}.to_json
  end
end

# Because I hate API Keys, this works using https://noembed.com/.
# It has support for a ton of backends besides Youtube, and supports regular
# and short youtube URLs, so not much filtering required at all.

def fetch_video_data(url)
  response = RestClient.get("https://noembed.com/embed?url=#{url}")
  video_data = JSON.parse(response)
  video_data['video_id'] = video_data['url'].split('=').last
  video_data['video_id'] = video_data['url'][17..-1] if video_data['url'][0..15] == 'https://youtu.be'
  video_data
end

# Main route that will redirect to the appropriate command route
post "/process_command" do
  data = json_params(request.body.read)
  redirect "/#{data['message_parts'][0].gsub('!', '')}", 307
end

# Song Request route
post "/sr" do
  json = json_params(request.body.read)
  song_url = json['message_parts'][1]
  user = json['user']
  song_metadata = fetch_video_data(song_url)

  # Reject the embed HTML code key in the hash as HAML tries to render this.
  $song_request_queue << {
    :user => user,
    :song_data => song_metadata
  }
  return {:status => 200, :message => "@#{user}, Song #{song_url} was added to queue"}.to_json
end

post "/sq" do
  json = json_params(request.body.read)
  user = json['user']

  return {:status => 200, :message => "@#{user}, the song queue is viewable at #{SHARED_CONFIG[:root_url]}/songqueue"}
end

get '/songqueue' do
  p $song_request_queue
  @song_queue = {:songs => $song_request_queue}
  haml :songqueue
end

# Catch-all route for commands that do not exist.
# NOTE: ANY COMMAND END POINTS MUST EXIST BEFORE THIS CATCH ALL.
post '/*' do
  data = json_params(request.body.read)
  return {:status => 200, :message => "Sorry #{data['user']}, command #{data['message_parts'][0]} does not exist."}.to_json
end
