require 'mv/sqlite/validation/base_decorator'
require 'mv/sqlite/active_record/connection_adapters/sqlite3_adapter_decorator'

module Mv
  module Sqlite
    class Railtie < ::Rails::Railtie
      initializer 'mv-sqlite.initialization', after: 'active_record.initialize_database' do
        ::ActiveRecord::ConnectionAdapters::SQLite3Adapter.send(:prepend, Mv::Sqlite::ActiveRecord::ConnectionAdapters::Sqlite3AdapterDecorator)
      end
    end
  end
end