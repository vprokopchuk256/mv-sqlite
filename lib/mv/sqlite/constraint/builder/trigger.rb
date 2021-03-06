module Mv
  module Sqlite
    module Constraint
      module Builder
        class Trigger < Mv::Core::Constraint::Builder::Trigger
          def create
            validation_builders.group_by(&:table_name).each do |table_name, validations|
              db.execute(drop_trigger_statement(table_name))
              db.execute(create_trigger_statement(table_name))
            end
          end

          def delete
            validation_builders.group_by(&:table_name).each do |table_name, validations|
              db.execute(drop_trigger_statement(table_name))
            end
          end

          def update new_constraint_builder
            delete
            new_constraint_builder.create
          end

          private


          def drop_trigger_statement table_name
            "DROP TRIGGER IF EXISTS #{name};" 
          end

          def create_trigger_statement table_name
            "CREATE TRIGGER #{name} BEFORE #{update? ? 'UPDATE' : 'INSERT'} ON #{table_name} FOR EACH ROW
             BEGIN
              #{trigger_body(table_name)};
             END;"
          end

          def trigger_body(table_name)
            validation_builders.select{|b| b.table_name == table_name }.collect(&:conditions).flatten.collect do |condition|
              "SELECT RAISE(ABORT, '#{condition[:message]}') WHERE NOT(#{condition[:statement]})".squish
            end.join("; \n")
          end
        end
      end
    end
  end
end