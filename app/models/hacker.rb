module Synthia::Model
  class Hacker < Sequel::Model

    def self.find_or_create(hacker_alias)
      hacker_alias = hacker_alias.to_s.downcase
      result = where(:alias => hacker_alias).first

      # Found a known CyberSpace Hacker Alias
      return result unless result.nil?

      # This is a new CyberSpace Hacker, let's register them
      now = Time.now
      insert(
        :alias => hacker_alias,
        :created_at => now,
        :updated_at => now
      )
    end
  end
end
