# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: mv-sqlite 2.2.5 ruby lib

Gem::Specification.new do |s|
  s.name = "mv-sqlite"
  s.version = "2.2.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Valeriy Prokopchuk"]
  s.date = "2016-02-24"
  s.description = "SQLite constraints in migrations similiar to ActiveRecord validations"
  s.email = "vprokopchuk@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "lib/mv-sqlite.rb",
    "lib/mv/sqlite/active_record/connection_adapters/sqlite3_adapter_decorator.rb",
    "lib/mv/sqlite/constraint/builder/trigger.rb",
    "lib/mv/sqlite/loader.rb",
    "lib/mv/sqlite/railtie.rb",
    "lib/mv/sqlite/services/create_regexp_function.rb",
    "lib/mv/sqlite/validation/active_model_presenter/format.rb",
    "lib/mv/sqlite/validation/builder/format.rb",
    "lib/mv/sqlite/validation/builder/trigger/absence.rb",
    "lib/mv/sqlite/validation/builder/trigger/custom.rb",
    "lib/mv/sqlite/validation/builder/trigger/exclusion.rb",
    "lib/mv/sqlite/validation/builder/trigger/format.rb",
    "lib/mv/sqlite/validation/builder/trigger/inclusion.rb",
    "lib/mv/sqlite/validation/builder/trigger/length.rb",
    "lib/mv/sqlite/validation/builder/trigger/presence.rb",
    "lib/mv/sqlite/validation/builder/trigger/sqlite_datetime_values.rb",
    "lib/mv/sqlite/validation/builder/trigger/trigger_column.rb",
    "lib/mv/sqlite/validation/builder/trigger/uniqueness.rb",
    "lib/mv/sqlite/validation/format.rb"
  ]
  s.homepage = "http://github.com/vprokopchuk256/mv-sqlite"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0")
  s.rubygems_version = "2.4.4"
  s.summary = "SQLite constraints in migrations similiar to ActiveRecord validations"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>, ["~> 4.1"])
      s.add_runtime_dependency(%q<sqlite3>, ["~> 1.3"])
      s.add_runtime_dependency(%q<mv-core>, ["~> 2.2.3"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.1"])
      s.add_development_dependency(%q<rspec-its>, ["~> 1.1"])
      s.add_development_dependency(%q<guard-rspec>, ["~> 4.5"])
    else
      s.add_dependency(%q<railties>, ["~> 4.1"])
      s.add_dependency(%q<sqlite3>, ["~> 1.3"])
      s.add_dependency(%q<mv-core>, ["~> 2.2.3"])
      s.add_dependency(%q<jeweler>, ["~> 2.0"])
      s.add_dependency(%q<rspec>, ["~> 3.1"])
      s.add_dependency(%q<rspec-its>, ["~> 1.1"])
      s.add_dependency(%q<guard-rspec>, ["~> 4.5"])
    end
  else
    s.add_dependency(%q<railties>, ["~> 4.1"])
    s.add_dependency(%q<sqlite3>, ["~> 1.3"])
    s.add_dependency(%q<mv-core>, ["~> 2.2.3"])
    s.add_dependency(%q<jeweler>, ["~> 2.0"])
    s.add_dependency(%q<rspec>, ["~> 3.1"])
    s.add_dependency(%q<rspec-its>, ["~> 1.1"])
    s.add_dependency(%q<guard-rspec>, ["~> 4.5"])
  end
end

