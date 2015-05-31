module Mv
  module Sqlite
    module Services
      class CreateRegexpFunction
        attr_reader :connection

        def initialize(connection)
          @connection = connection
        end

        def execute
          connection.create_function( 'REGEXP', 2 ) do |func, pattern, expression|
            func.result = expression =~ Regexp.new(pattern.to_s, Regexp::IGNORECASE) ? 1 : 0
          end
        end
      end
    end
  end
end
