require 'mv/sqlite/validation/builder/trigger/trigger_column'

module Mv
  module Sqlite
    module Validation
      module Builder
        module Trigger
          class Presence < Mv::Core::Validation::Builder::Presence
            include TriggerColumn
          end
        end
      end
    end
  end
end
