require 'mv/sqlite/validation/builder/trigger/sqlite_datetime_values'
require 'mv/sqlite/validation/builder/trigger/trigger_column'

module Mv
  module Sqlite
    module Validation
      module Builder
        module Trigger
          class Inclusion < Mv::Core::Validation::Builder::Inclusion
            include SqliteDatetimeValues
            include TriggerColumn
          end
        end
      end
    end
  end
end
