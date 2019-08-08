module Synthia::Model
  class Session < Sequel::Model

    STATUSES = %i[
      active
      complete
    ].freeze

    def self.boot_session(hacker)
      # TODO: Validate that `hacker` can be allowed to actually start the session
      now = Time.now
      active_session = first(:status => :active, :deleted_at => nil)
      if active_session.nil?
        insert(
          :status => :active,
          :created_at => now,
          :updated_at => now
        )
        return 'NEW SESSION ACTIVATED!'
      end

      'There is already an Active Session.'
    end

    def self.active_status
      :active
    end
  end
end
