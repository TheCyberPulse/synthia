module Synthia::Model
  class SessionHacker < Synthia::Model::Base

    def self.link_up(hacker)
      active_session = Synthia::Model::Session.active_session
      valid_link = true
      valid_link = false if active_session.nil?
      valid_link = false if hacker[:id].to_i.zero?

      return Synthia::Config['forbidden_response'].to_s unless valid_link

      now = Time.now
      session_id = active_session[:id].to_i
      hacker_id = hacker[:id].to_i

      return 'Invalid Link Data!' if session_id.zero? || hacker_id.zero?

      current_link = where(
        :session_id => session_id,
        :hacker_id => hacker_id,
        :deleted_at => nil
      )

      return 'Already Linked Up to Session!' if current_link.count.positive?

      result = insert(
        :session_id => session_id,
        :hacker_id => hacker_id,
        :created_at => now,
        :updated_at => now
      )

      'Successfully Linked Up to Session!' if result.to_i.positive?
    end
  end
end
