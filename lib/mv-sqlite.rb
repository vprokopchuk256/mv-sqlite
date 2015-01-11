require 'mv-core'
require 'mv/sqlite/railtie'

require 'mv/sqlite/constraint/builder/trigger'

require 'mv/sqlite/validation/builder/trigger/exclusion'
require 'mv/sqlite/validation/builder/trigger/inclusion'
require 'mv/sqlite/validation/builder/trigger/length'
require 'mv/sqlite/validation/builder/trigger/presence'
require 'mv/sqlite/validation/builder/trigger/uniqueness'

ActiveSupport.on_load(:mv_core) do

  #constraint builders
  Mv::Core::Constraint::Builder::Factory.register_builders(
    Mv::Core::Constraint::Trigger => Mv::Sqlite::Constraint::Builder::Trigger,
  )
  
  #validation builders in trigger
  Mv::Sqlite::Constraint::Builder::Trigger.validation_builders_factory.register_builders(
    Mv::Core::Validation::Exclusion => Mv::Sqlite::Validation::Builder::Trigger::Exclusion,
    Mv::Core::Validation::Inclusion => Mv::Sqlite::Validation::Builder::Trigger::Inclusion,
    Mv::Core::Validation::Length    => Mv::Sqlite::Validation::Builder::Trigger::Length,
    Mv::Core::Validation::Presence  => Mv::Sqlite::Validation::Builder::Trigger::Presence,
    Mv::Core::Validation::Uniqueness      => Mv::Sqlite::Validation::Builder::Trigger::Uniqueness
  )
end



