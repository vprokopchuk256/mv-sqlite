source "http://rubygems.org"

gem 'railties', '~> 4.1'
gem "sqlite3", '~> 1.3'
gem "mv-core", git: 'git@github.com:vprokopchuk256/mv-core.git', branch: 'master'

group :development do
  gem "jeweler", '~> 2.0'
  gem "rspec", '~> 3.1'
  gem 'rspec-its'
  gem 'guard-rspec', require: false
  gem 'mv-test', '~> 1.0'
end

group :test do
  gem 'pry-byebug'
  gem 'coveralls', require: false
  gem 'rb-fsevent'
  gem 'terminal-notifier-guard'
end
