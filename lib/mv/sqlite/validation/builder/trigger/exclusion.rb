require 'mv/sqlite/validation/builder/trigger/mysql_datetime_values'
require 'mv/sqlite/validation/builder/trigger/trigger_column'

module Mv
  module Sqlite
    module Validation
      module Builder
        module Trigger
          class Exclusion < Mv::Core::Validation::Builder::Exclusion
            include MysqlDatetimeValues
            include TriggerColumn
          end
        end
      end
    end
  end
end