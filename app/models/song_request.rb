module Synthia::Model
  class SongRequest < Sequel::Model

    def self.log_song_request(hacker, url)
      now = Time.now
      insert(
        :hacker_id => hacker[:id],
        :url => url,
        :created_at => now,
        :updated_at => now
      )
    end

    def self.queue
      where(:played => false, :deleted_at => nil).order(:id)
    end
  end
end
