module Mv
  module Sqlite
    module Validation
      module BaseDecorator
        def available_as 
          super.reject{ |as| as.to_sym == :check }
        end
      end
    end
  end
end