require 'mv/sqlite/validation/base_decorator'

module Mv
  module Sqlite
    class Railtie < ::Rails::Railtie
      initializer 'mv-sqlite.initialization' do
        ActiveSupport.on_load(:active_record) do
          ::ActiveRecord::ConnectionAdapters::SQLite3Adapter.send(:prepend, Mv::Core::ActiveRecord::ConnectionAdapters::AbstractAdapterDecorator)
        end

        ActiveSupport.on_load(:mv_core) do
          Mv::Core::Validation::Base.send(:prepend, Mv::Sqlite::Validation::BaseDecorator)
        end
      end
    end
  end
end