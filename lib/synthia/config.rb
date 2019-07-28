require 'yaml'
require 'active_support/core_ext/string'

module Synthia
  module Config
    @@settings = {}

    def self.load_commands
      command_array = Dir.glob('app/commands/*.rb').map do |filename|
        filename.to_s.gsub('app/commands/', '').gsub('.rb', '').titleize.gsub(' ', '')
      end
      @@settings.merge! :commands => command_array
    end

    def self.load_yaml(file)
      @@settings.merge! ::YAML::load_file file
    end

    def self.[](key)
      @@settings[key.to_s]
    end

    def self.settings
      @@settings
    end
  end
end
