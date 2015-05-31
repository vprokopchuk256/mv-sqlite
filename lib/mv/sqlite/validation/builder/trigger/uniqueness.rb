require 'mv/sqlite/validation/builder/trigger/trigger_column'

module Mv
  module Sqlite
    module Validation
      module Builder
        module Trigger
          class Uniqueness < Mv::Core::Validation::Builder::Uniqueness
            include TriggerColumn
          end
        end
      end
    end
  end
end
