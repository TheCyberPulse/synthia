module Synthia
  def self.init
    load_config
  end

  def self.load_config
    load 'lib/synthia/config.rb'
    Synthia::Config.load_yaml 'config/application.yml'
    Synthia::Config.load_yaml 'config/summer.yml'
    Synthia::Config.load_commands
  end
end
