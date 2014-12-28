require 'mv-core'
require 'mv/sqlite/validation/base_decorator'
require 'mv/sqlite/railtie'

ActiveSupport.on_load(:mv_core) do
  Mv::Core::Validation::Base.send(:prepend, Mv::Sqlite::Validation::BaseDecorator)
end



