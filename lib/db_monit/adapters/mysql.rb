require 'mysql2'

module DbMonit
  module Adapters

    class Mysql

      attr_reader :client

      def initialize(hash_data)
        @client = Mysql2::Client.new(hash_data)
      end

      def threads(variable = nil, _match = nil, count = false)
        _query = "SELECT "
        _query << (count ? "count(*) as count" : "*")
        _query << " FROM performance_schema.threads"

        if variable
          _query << " WHERE #{variable} "
          _query << (null_value?(_match) ? "is NULL" : "= '#{_match}'")
        end

        client.query(_query)
      end

      def status(global = false, variable = nil, count = false)
        _query = "SELECT "
        _query << (count ? "variable_value as count" : "*")
        _query << " FROM performance_schema.#{global ? 'global' : 'session'}_status"

        if variable
          _query << " WHERE variable_name = '#{variable}'"
        end

        client.query(_query)
      end

      private

      def null_value?(value)
        %q{null NULL Null}.include?(value)
      end

    end

  end
end
