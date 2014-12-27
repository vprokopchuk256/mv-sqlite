module Mv
  module Sqlite
    module ActiveRecord
      module ConnectionAdapters
        module Sqlite3AdapterDecorator
          include Mv::Core::ActiveRecord::ConnectionAdapters::AbstractAdapterDecorator

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