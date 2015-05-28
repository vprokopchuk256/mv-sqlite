$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'rspec/its'
require 'mv-sqlite'
require 'active_record/connection_adapters/sqlite3_adapter'
require 'mv/sqlite/loader'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

require 'coveralls'
Coveralls.wear!

ActiveRecord::Migration.verbose = false

RSpec.configure do |config|
  config.before :each do
    ActiveRecord::Base.remove_connection if ::ActiveRecord::Base.connected?
    ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
  end
end
