module Synthia::Model
  class Cred < Sequel::Model

    def self.give_cred(recipient, amount)
      cred = first(:hacker_id => recipient[:id].to_i)
      now = Time.now
      if cred.nil?
        insert(
          :hacker_id => recipient[:id].to_i,
          :amount => amount.to_i,
          :created_at => now,
          :updated_at => now
        )
        return amount.to_i
      end
      new_cred_value = cred[:amount].to_i + amount.to_i
      cred.update :amount => new_cred_value, :updated_at => now
      new_cred_value
    end

    def self.check_balance(hacker)
      cred = first(:hacker_id => hacker[:id].to_i)
      cred[:amount].to_i unless cred.nil?
    end
  end
end
