module Synthia::Model
  class SessionHacker < Sequel::Model

    def self.link_up(hacker, session)
      valid_link = true
      valid_link = false unless session[:status] == Synthia::Model.active_status
      valid_link = false if hacker[:id].to_i.zero?
      valid_link = false if session[:id].to_i.zero?

      return Synthia::Config['forbidden_response'].to_s unless valid_link

      now = Time.now

      insert(
        :session_id => session[:id].to_i,
        :hacker_id => hacker[:id].to_i,
        :created_at => now,
        :updated_at => now
      )
    end
  end
end
