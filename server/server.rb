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

    get '/play-requests/:song_type/:song_id?' do
      load_model :default_song
      load_model :song_request
      current_song = ''

      case params[:song_type].to_s
      when 'default'
        current_song =
          Synthia::Model::DefaultSong.queue.first if params[:song_id].to_i.zero? ||
          Synthia::Model::DefaultSong.where(:id => params[:song_id].to_i).first
      when 'request'
        current_song =
          Synthia::Model::SongRequest.queue.first if params[:song_id].to_i.zero? ||
          Synthia::Model::SongRequest.where(:id => params[:song_id].to_i).first
      end

      p '********************************'
      p current_song
      p '********************************'
      url = current_song[:url].to_s if current_song.respond_to?(:[]) && current_song.present?
      current_song_video_id = 0
      current_song_video_id = url.split('v=')[1].split('&')[0].to_s if url.to_s.include?('v=')
      current_song.play! if current_song.present?
      queue = Synthia::Model::SongRequest.queue + Synthia::Model::DefaultSong.queue

      render_template(
        'index.html.haml',
        {
          :@current_song_video_id => current_song_video_id,
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
