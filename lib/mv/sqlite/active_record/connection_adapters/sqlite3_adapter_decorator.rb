require 'mv/sqlite/services/create_regexp_function'

module Mv
  module Sqlite
    module ActiveRecord
      module ConnectionAdapters
        module Sqlite3AdapterDecorator
          include Mv::Core::ActiveRecord::ConnectionAdapters::AbstractAdapterDecorator

          def initialize(connection, *args)
            super

            Mv::Sqlite::Services::CreateRegexpFunction.new(connection).execute
          end

          protected

          def alter_table(table_name, options = {})
            Mv::Core::Migration::Base.with_suppressed_validations do
              super
            end
          end
        end
      end
    end
  end
end
