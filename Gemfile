source "http://rubygems.org"

gem 'railties', '~> 4.1'
gem "sqlite3", '~> 1.3'
# gem "mv-core", '~> 2.0'
gem "mv-core", path: '/projects/mv/mv-core'

group :development do
  gem "jeweler", '~> 2.0'
  gem "rspec", '~> 3.1'
  gem 'rspec-its', '~> 1.1'
  gem 'guard-rspec', '~> 4.5', require: false
end

group :test do
  gem 'pry-byebug'
  gem 'coveralls', require: false
  gem 'rb-fsevent'
  gem 'terminal-notifier-guard'
end
