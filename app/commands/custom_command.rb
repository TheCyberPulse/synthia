module Synthia::Command
  load 'lib/synthia/command.rb'

  class CustomCommand < Synthia::Command::Base

    def self.execute(*args)
      'Please do not call the Custom Command directly.'
    end

    def self.find_and_execute_command(command_name)

      command = DB[:custom_commands].first(:name => command_name.to_s, :deleted_at => nil) ||
        DB[:custom_commands].where(:deleted_at => nil).first(Sequel.like(:aliases, "%|#{command_name.to_s}|%"))

      command[:response_content] unless command.nil?
    end
  end
end
