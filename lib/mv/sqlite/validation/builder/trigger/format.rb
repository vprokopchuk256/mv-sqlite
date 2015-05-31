require 'mv/sqlite/validation/builder/format'
require 'mv/sqlite/validation/builder/trigger/trigger_column'

module Mv
  module Sqlite
    module Validation
      module Builder
        module Trigger
          class Format < Mv::Sqlite::Validation::Builder::Format
            include TriggerColumn
          end
        end
      end
    end
  end
end
