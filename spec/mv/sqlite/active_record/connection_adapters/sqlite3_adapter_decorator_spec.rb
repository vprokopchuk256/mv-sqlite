require 'spec_helper'

require 'mv/sqlite/active_record/connection_adapters/sqlite3_adapter_decorator'

describe Mv::Sqlite::ActiveRecord::ConnectionAdapters::Sqlite3AdapterDecorator do
  before do
    Mv::Core::Services::CreateMigrationValidatorsTable.new.execute
    ::ActiveRecord::ConnectionAdapters::SQLite3Adapter.send(:prepend, described_class)

    ActiveRecord::Base.connection.create_table :table_name do |t|
      t.string :column_name
    end

  end

  subject do
    Class.new(::ActiveRecord::Migration) do
      def change
        change_table :table_name, id: false do |t|
          t.change :column_name, :string, validations: { length: { is: 5 } }
        end
      end
    end.new('TestMigration', '20141118164617').migrate(:up)
  end

  it 'should not initiate drop / create way to alter table in sqlite driver' do
    expect(Mv::Core::Migration::Operations::DropTable).not_to receive(:new)
    subject
  end
end