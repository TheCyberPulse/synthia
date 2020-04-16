require 'securerandom'

module Synthia::Model
  class Base

    def self.query(sql, params)
      return db.exec(sql) if params.to_a.count.zero?
      query_name = "#{Time.now.to_i}-#{SecureRandom.uuid}"
      db.prepare query_name, sql
      db.exec_prepared query_name, params
    end
  end
end
