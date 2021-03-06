module Synthia::Command
  load 'lib/synthia/command.rb'

  class Cred < Synthia::Command::Base

    def self.execute(hacker, input)
      action = input.to_a[0].to_s.downcase
      target_hacker_alias = input.to_a[1].to_s.downcase
      amount = input.to_a[2].to_i

      return Synthia::Config['forbidden_response'].to_s if amount > 100

      if !Synthia::Config['su_hackers'].to_a.include?(hacker[:alias].to_s) && action == 'give'
        return Synthia::Config['forbidden_response'].to_s
      end

      if action.empty? || (action == 'balance' && target_hacker_alias.empty?)
        action = 'balance'
        target_hacker_alias = hacker[:alias].to_s
      end

      target_hacker = Synthia::Model::Hacker.first :alias => target_hacker_alias

      return Synthia::Config['unknown_response'].to_s if target_hacker.nil?

      case action
      when 'give'
        balance = Synthia::Model::Cred.give_cred target_hacker, amount
        "#{amount} cred given to Hacker Alias #{target_hacker[:alias]}. Their new balance of cred is #{balance}"
      when 'balance'
        balance = Synthia::Model::Cred.check_balance(target_hacker)
        "Hacker Alias #{target_hacker[:alias].to_s} has #{balance.to_i} cred."
      else
        Synthia::Config['unknown_response'].to_s
      end

    end
  end
end
