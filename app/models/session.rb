module Synthia::Model
  class Session < Sequel::Model

    STATUSES = %i[
      active
      complete
    ].freeze

    def self.active_session
      first :status => 'active', :deleted_at => nil
    end

    def self.active_status
      :active
    end

    def self.boot_session(hacker)
      valid_su_hacker = Synthia::Config['su_hackers'].to_a.include?(hacker[:alias].to_s)
      return Synthia::Config['forbidden_response'].to_s unless valid_su_hacker

      now = Time.now
      active_session = where(:status => 'active', :deleted_at => nil)

      # We only want one Session active at a time.
      return 'Multiple Sessions Active! Please correct in database!' if active_session.count > 1

      if active_session.count.zero?
        insert(
          :status => 'active',
          :created_at => now,
          :updated_at => now
        )
        return 'NEW SESSION ACTIVATED!'
      end

      'There is already an Active Session.'
    end
  end
end
