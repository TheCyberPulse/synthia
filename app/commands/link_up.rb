module Synthia::Command
  load 'lib/synthia/command.rb'

  class LinkUp < Synthia::Command::Base

    def self.execute(hacker, *args)
      Synthia::Model::SessionHacker.link_up hacker
    end
  end
end
