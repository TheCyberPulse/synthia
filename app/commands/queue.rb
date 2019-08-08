module Synthia::Command
  load 'lib/synthia/command.rb'

  class Queue < Synthia::Command::Base

    def self.execute(*args)
      response = ''
      Synthia::Model::SongRequest.queue.each do |record|
        response += " | #{record[:url]}"
      end
      response
    end
  end
end
