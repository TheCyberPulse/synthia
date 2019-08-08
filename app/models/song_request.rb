module Synthia::Model
  class SongRequest < Sequel::Model

    def self.log_song_request(hacker, url)
      insert(
        :hacker_id => hacker[:id],
        :url => url
      )
    end

    def self.queue
      where(:played => false).order(:id)
    end
  end
end
