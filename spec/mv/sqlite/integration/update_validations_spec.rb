require 'spec_helper'

describe 'Update validation scenarios' do
  before do
    Mv::Core::Services::CreateMigrationValidatorsTable.new.execute
    ::ActiveRecord::ConnectionAdapters::SQLite3Adapter.send(:prepend, Mv::Sqlite::ActiveRecord::ConnectionAdapters::Sqlite3AdapterDecorator)
  end

  describe 'update column in change_table block' do
    before do
      Class.new(::ActiveRecord::Migration[5.0]) do
        def change
          create_table :table_name, id: false do |t|
            t.string :column_name, validates: { uniqueness: { as: :trigger, on: :create } }
          end
        end
      end.new('TestMigration', '20141118164617').migrate(:up)
    end

    subject do
       Class.new(::ActiveRecord::Migration[5.0]) do
        def change
          change_table :table_name, id: false do |t|
            t.change :column_name, :string, validates: { uniqueness: { as: :index } }
          end
        end
      end.new('TestMigration', '20141118164617').migrate(:up)
    end

    it "deletes trigger constraint" do
      expect_any_instance_of(Mv::Sqlite::Constraint::Builder::Trigger).to receive(:delete).once
      subject
    end

    it "creates index constraint" do
      expect_any_instance_of(Mv::Core::Constraint::Builder::Index).to receive(:create).once
      subject
    end

    it "updates migration validator" do
      expect{ subject }.to change{Mv::Core::Db::MigrationValidator.first.options}.from(as: :trigger, on: :create)
                                                                                  .to(as: :index)
    end
  end

  describe 'standalone update column statement' do
    before do
      Class.new(::ActiveRecord::Migration[5.0]) do
        def change
          create_table :table_name, id: false do |t|
            t.string :column_name, validates: { uniqueness: { as: :trigger, on: :create } }
          end
        end
      end.new('TestMigration', '20141118164617').migrate(:up)
    end

    subject do
       Class.new(::ActiveRecord::Migration[5.0]) do
        def change
          change_column :table_name, :column_name, :string, validates: { uniqueness: { as: :index } }
        end
      end.new('TestMigration', '20141118164617').migrate(:up)
    end

    it "deletes trigger constraint" do
      expect_any_instance_of(Mv::Sqlite::Constraint::Builder::Trigger).to receive(:delete).once
      subject
    end

    it "creates index constraint" do
      expect_any_instance_of(Mv::Core::Constraint::Builder::Index).to receive(:create).once
      subject
    end

    it "updates migration validator" do
      expect{ subject }.to change{Mv::Core::Db::MigrationValidator.first.options}.from(as: :trigger, on: :create)
                                                                                  .to(as: :index)
    end
  end
end
