require 'mv/sqlite/constraint/builder/trigger'

require 'mv/sqlite/validation/builder/trigger/exclusion'
require 'mv/sqlite/validation/builder/trigger/inclusion'
require 'mv/sqlite/validation/builder/trigger/length'
require 'mv/sqlite/validation/builder/trigger/presence'
require 'mv/sqlite/validation/builder/trigger/absence'
require 'mv/sqlite/validation/builder/trigger/uniqueness'
require 'mv/sqlite/validation/builder/trigger/format'
require 'mv/sqlite/validation/builder/trigger/custom'

require 'mv/sqlite/active_record/connection_adapters/sqlite3_adapter_decorator'

#constraint builders
Mv::Core::Constraint::Builder::Factory.register_builders(
  Mv::Core::Constraint::Trigger => Mv::Sqlite::Constraint::Builder::Trigger,
)

#validation builders in trigger
Mv::Sqlite::Constraint::Builder::Trigger.validation_builders_factory.register_builders(
  Mv::Core::Validation::Exclusion   => Mv::Sqlite::Validation::Builder::Trigger::Exclusion,
  Mv::Core::Validation::Inclusion   => Mv::Sqlite::Validation::Builder::Trigger::Inclusion,
  Mv::Core::Validation::Length      => Mv::Sqlite::Validation::Builder::Trigger::Length,
  Mv::Core::Validation::Presence    => Mv::Sqlite::Validation::Builder::Trigger::Presence,
  Mv::Core::Validation::Absence     => Mv::Sqlite::Validation::Builder::Trigger::Absence,
  Mv::Core::Validation::Uniqueness  => Mv::Sqlite::Validation::Builder::Trigger::Uniqueness,
  Mv::Core::Validation::Format      => Mv::Sqlite::Validation::Builder::Trigger::Format,
  Mv::Core::Validation::Custom      => Mv::Sqlite::Validation::Builder::Trigger::Custom
)

::ActiveRecord::ConnectionAdapters::SQLite3Adapter.send(
  :prepend,
  Mv::Sqlite::ActiveRecord::ConnectionAdapters::Sqlite3AdapterDecorator
)
