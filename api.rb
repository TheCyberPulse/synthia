require 'rest-client'
require 'sinatra'
require 'json'
require 'yaml'

SHARED_CONFIG = YAML.load(File.read("./config/shared_config.yaml"))

$song_request_queue = []
$current_song = {}

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

# Thread Safety should prevent issues from writing to the global song request queue, uses mutexes
configure do
  set :lock, true
  set :protection, except: [:frame_options]
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
  if $current_song.empty?
    $current_song = {:user => user, :song_data => song_metadata }
  else
    $song_request_queue << {
      :user => user,
      :song_data => song_metadata
    }
  end

  return {:status => 200, :message => "@#{user}, Song #{song_metadata['title']} was added to queue"}.to_json
end

post "/sq" do
  json = json_params(request.body.read)
  user = json['user']

  return {:status => 200, :message => "@#{user}, the song queue is viewable at #{SHARED_CONFIG[:root_url]}/songqueue"}.to_json
end

get '/songqueue' do
  @song_queue = {:current_song => $current_song, :songs => $song_request_queue}
  haml :publicsongqueue
end

get '/player' do
  @song_queue = {:current_song => $current_song, :songs => $song_request_queue}
  haml :player
end

post '/removesong' do
  json = json_params(request.body.read)
  requester = json['requester']
  video_id = json['video-id']
  $song_request_queue.delete_if do |song_hash|
    song_hash[:user] == requester && song_hash[:song_data]['video_id'] == video_id
  end

  song = $song_request_queue.select do |song_hash|
    song_hash[:user] == requester && song_hash[:song_data]['video_id'] == video_id
  end

  if song.empty?
    return {:status => 200}.to_json
  else
    return {:status => 200}.to_json
  end
end

get '/nextsong' do
  next_song = $song_request_queue.shift
  $current_song = next_song.nil? ? {} : next_song
  return {:status => 200}.to_json
end

# Catch-all route for commands that do not exist.
# NOTE: ANY COMMAND END POINTS MUST EXIST BEFORE THIS CATCH ALL.
post '/*' do
  data = json_params(request.body.read)
  return {:status => 200, :message => "Sorry #{data['user']}, command #{data['message_parts'][0]} does not exist."}.to_json
end
