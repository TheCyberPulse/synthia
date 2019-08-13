module Synthia::Command
  load 'lib/synthia/command.rb'

  class BootSession < Synthia::Command::Base

    def self.execute(hacker, *args)
      Synthia::Model::Session.boot_session hacker
    end
  end
end
