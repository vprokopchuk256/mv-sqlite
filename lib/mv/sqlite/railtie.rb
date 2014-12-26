require 'mv/sqlite/validation/base_decorator'

module Mv
  module Sqlite
    class Railtie < ::Rails::Railtie

      initializer 'mv-sqlite.initialization', after: 'mv-core.initialization.active_record' do
        Mv::Core::Validation::Base.send(:prepend, Mv::Sqlite::Validation::BaseDecorator)
      end
    end
  end
end