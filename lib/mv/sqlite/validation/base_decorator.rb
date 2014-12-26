module Mv
  module Sqlite
    module Core
      module Validation
        module ExclusionDecorator
          def available_as 
            super.reject{ |as| as.to_sym == :check }
          end
        end
      end
    end
  end
end