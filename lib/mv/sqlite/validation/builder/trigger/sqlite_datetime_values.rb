module Mv
  module Sqlite
    module Validation
      module Builder
        module Trigger
          module SqliteDatetimeValues
            protected

            def db_value value
              return "datetime('#{value.strftime('%Y-%m-%d %H:%M:%S')}')" if value.is_a?(DateTime)
              return "datetime('#{value.strftime('%Y-%m-%d %H:%M:%S')}')" if value.is_a?(Time)
              return "date('#{value.strftime('%Y-%m-%d')}')" if value.is_a?(Date)
              super
            end
          end
        end
      end
    end
  end
end
