module Mv
  module Sqlite
    class Railtie < ::Rails::Railtie
      initializer 'mv-sqlite.initialization', after: 'active_record.initialize_database' do
        if defined?(::ActiveRecord::ConnectionAdapters::SQLite3Adapter) &&
           ActiveRecord::Base.connection.is_a?(::ActiveRecord::ConnectionAdapters::SQLite3Adapter)
           require 'mv/sqlite/loader'
        end
      end
    end
  end
end
