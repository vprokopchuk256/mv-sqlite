require 'spec_helper'

require 'mv/sqlite/validation/builder/trigger/format'

describe Mv::Sqlite::Validation::Builder::Trigger::Format do
  def format(opts = {})
    Mv::Sqlite::Validation::Format.new(:table_name,
                                        :column_name,
                                        { with: /exp/, message: 'is not valid' }.merge(opts))
  end

  describe "#conditions" do
    subject { described_class.new(format(opts)).conditions }

    describe "when regex passed" do
      let(:opts) { { with: /exp/ } }

      it { is_expected.to eq([{
        statement: "NEW.column_name IS NOT NULL AND NEW.column_name REGEXP 'exp'",
        message: 'ColumnName is not valid'
      }]) }
    end
  end
end
