module Synthia::Model
  class DefaultSong < Base

    def self.queue
      now = Time.now
      # TODO: Fix this jank
      # Was attempting to use Sequel to pull all non-deleted DefaultSong
      # records which had not been played within the past day, but
      # Sequel sux or I do...not sure which just yet.
      #where(Sequel[:last_played_at] < now << 1, :deleted_at => nil).order(:last_played_at)
      where(:deleted_at => nil).order(:last_played_at)
    end

    def play!
      now = Time.now
      update(
        :last_played_at => now,
        :updated_at => now
      )
    end
  end
end
