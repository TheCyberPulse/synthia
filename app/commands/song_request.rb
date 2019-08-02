module Synthia::Command
  load 'lib/synthia/command.rb'

  class SongRequest < Synthia::Command::Base

    def self.execute(hacker, input)
      url = input.to_a[0].to_s
      return 'Invalid YouTube URL Submitted.' unless valid_url?(url)
      Synthia::Model::SongRequest.log_song_request hacker, url
      'Song Request Logged!'
    end

    def self.valid_url?(url)
      return true if url[0,21] == 'https://www.youtu.be/'
      return true if url[0,24] == 'https://www.youtube.com/'
      return true if url[0,23] == 'http://www.youtube.com/'
      return true if url[0,20] == 'http://www.youtu.be/'
      return true if url[0,17] == 'https://youtu.be/'
      return true if url[0,20] == 'https://youtube.com/'
      return true if url[0,19] == 'http://youtube.com/'
      return true if url[0,16] == 'http://youtu.be/'
      false
    end
  end
end
