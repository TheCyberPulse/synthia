require 'sinatra'
require 'sequel'
require 'haml'
load 'lib/synthia.rb'
Synthia::init

module Synthia
  class Server < Sinatra::Base

    set :root, "#{File.dirname(__FILE__)}"

    # Connect to database
    DB = Sequel.postgres(
      Synthia::Config['database']['name'],
      :user => Synthia::Config['database']['username'],
      :password => Synthia::Config['database']['password'],
      :host => Synthia::Config['database']['host'],
      :port => Synthia::Config['database']['port']
    )

    get '/play-requests/:song_request_id?' do
      load_model :song_request
      current_song_request =
        Synthia::Model::SongRequest.queue.first if params[:song_request_id].to_i.zero? ||
        Synthia::Model::SongRequest.where(:id => params[:song_request_id].to_i).first
      url = current_song_request[:url].to_s if current_song_request.respond_to?(:[])
      current_song_request_video_id = 0
      current_song_request_video_id = url.split('v=')[1].split('&')[0].to_s if url.to_s.include?('v=')
      current_song_request.play! if current_song_request.present?
      queue = Synthia::Model::SongRequest.queue
      render_template(
        'index.html.haml',
        {
          :@current_song_request => current_song_request,
          :@current_song_request_video_id => current_song_request_video_id,
          :@queue => queue.to_a
        }
      )
    end

    private

    def render_template(template_path, locals)
      template = File.open("#{Dir.pwd}/app/views/#{template_path}").read
      Haml::Engine.new(template).render(Object.new, locals)
    end

    def load_model(name)
      load "#{Dir.pwd}/app/models/#{name.to_s}.rb"
    end
  end
end
