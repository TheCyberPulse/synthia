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

    get '/synthia-says' do
      load_model :hacker
      hacker = Synthia::Model::Hacker.find_or_create('xeraen')
      render_template 'index.html.haml', {:@things => hacker}
    end

    def render_template(template_path, locals)
      template = File.open("#{Dir.pwd}/app/views/#{template_path}").read
      Haml::Engine.new(template).render(Object.new, locals)
    end

    def load_model(name)
      load "#{Dir.pwd}/app/models/#{name.to_s}.rb"
    end
  end
end
