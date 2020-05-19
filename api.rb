require 'sinatra'
require 'json'

def json_params(request_data)
  begin
    JSON.parse(request_data)
  rescue
    halt 400, {:message => 'Invalid JSON'}.to_json
  end
end

#{"message_parts"=>["!sr", "testurl"], "user"=>"ntacman"}

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
  return {:status => 200, :message => "@#{user}, Song #{song_url} was added to queue"}.to_json
end

# Catch-all route for commands that do not exist.
# NOTE: ANY COMMAND END POINTS MUST EXIST BEFORE THIS CATCH ALL.
post '/*' do
  data = json_params(request.body.read)
  return {:status => 200, :message => "Sorry #{data['user']}, command #{data['message_parts'][0]} does not exist."}.to_json
end
