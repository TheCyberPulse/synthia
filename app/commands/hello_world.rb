module Synthia
  load 'lib/synthia/command.rb'

  class HelloWorld < Synthia::Command

    def self.execute
      # DO A THING
      'This is a message that I am sending into chat, CyberSpace Hackers.'
    end
  end
end
