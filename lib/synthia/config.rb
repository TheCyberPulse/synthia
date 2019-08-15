require 'yaml'
require 'active_support/core_ext/string'

module Synthia
  module Config
    @@settings = {}

    def self.load_commands
      command_hash = {}
      Dir.glob('app/commands/*.rb').each do |filename|
        class_name = filename.to_s.gsub('app/commands/', '').gsub('.rb', '').titleize.gsub(' ', '')
        command_hash.merge! class_name.downcase => class_name
      end
      @@settings.merge! 'commands' => command_hash
    end

    def self.load_special_commands
      special_commands = {
        'boot' => 'BootSession',
        'creds' => 'Cred',
        'songrequest' => 'SongRequest',
        'sr' => 'SongRequest'
      }
      @@settings['commands'].merge! special_commands
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
