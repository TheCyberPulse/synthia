module Synthia::Model
  class Cred < Synthia::Model::Base

    def self.give_cred(recipient, amount)
      now = Time.now
      cred = query 'SELECT * FROM cred WHERE hacker_id = $1 LIMIT 1;', recipient[:id].to_i

      if cred.nil? || cred[:id].to_i.zero?
        query(
          'INSERT INTO cred (hacker_id, amount, created_at, updated_at) VALUES ($1, $2, $3, $4);',
          [recipient[:id].to_i, amount.to_i, now, now]
        )
        return amount.to_i
      end
      new_cred_value = cred[:amount].to_i + amount.to_i
      query(
        'UPDATE cred SET amount = $1, updated_at = $2 WHERE id = $3;',
        [new_cred_value, now, cred[:id].to_i]
      )
      new_cred_value
    end

    def self.check_balance(hacker)
      cred = query 'SELECT * FROM cred WHERE hacker_id = $1 LIMIT 1;', recipient[:id].to_i
      cred[:amount].to_i unless cred.nil?
    end
  end
end
