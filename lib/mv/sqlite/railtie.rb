require 'mv/sqlite/validation/base_decorator'
require 'mv/sqlite/active_record/connection_adapters/sqlite3_adapter_decorator'

module Mv
  module Sqlite
    class Railtie < ::Rails::Railtie
      initializer 'mv-sqlite.initialization' do
        ActiveSupport.on_load(:active_record) do
          ::ActiveRecord::ConnectionAdapters::SQLite3Adapter.send(:prepend, described_class)
        end

        ActiveSupport.on_load(:mv_core) do
          Mv::Core::Validation::Base.send(:prepend, Mv::Sqlite::Validation::BaseDecorator)
        end
      end
    end
  end
end