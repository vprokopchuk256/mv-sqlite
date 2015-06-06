module Mv
  module Sqlite
    module Validation
      module Builder
        class Format < Mv::Core::Validation::Builder::Format
          def apply_with stmt
            "#{stmt} REGEXP #{db_value(with)}"
          end
        end
      end
    end
  end
end
