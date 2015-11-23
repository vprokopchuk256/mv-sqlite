require 'spec_helper'

require 'mv/sqlite/validation/builder/trigger/inclusion'

describe Mv::Sqlite::Validation::Builder::Trigger::Inclusion do
  def inclusion(opts = {})
    Mv::Core::Validation::Inclusion.new(:table_name,
                                        :column_name,
                                        { in: [1, 5], message: 'must be included' }.merge(opts))
  end

  describe "#conditions" do
    subject { described_class.new(inclusion(opts)).conditions }

    describe "when dates array passed" do
      let(:opts) { { in: [Date.new(2001, 1, 1), Date.new(2002, 2, 2)] } }

      it { is_expected.to eq([{
        statement: "NEW.column_name IS NOT NULL AND NEW.column_name IN (date('2001-01-01'), date('2002-02-02'))",
        message: 'column_name must be included'
      }]) }
    end

    describe "when date times array passed" do
      let(:opts) { { in: [DateTime.new(2001, 1, 1, 1, 1, 1), DateTime.new(2002, 2, 2, 2, 2, 2)] } }

      it { is_expected.to eq([{
        statement: "NEW.column_name IS NOT NULL AND NEW.column_name IN (datetime('2001-01-01 01:01:01'), datetime('2002-02-02 02:02:02'))",
        message: 'column_name must be included'
      }]) }
    end

    describe "when date times array passed" do
      let(:opts) { { in: [Time.new(2001, 1, 1, 1, 1, 1), Time.new(2002, 2, 2, 2, 2, 2)] } }

      it { is_expected.to eq([{
        statement: "NEW.column_name IS NOT NULL AND NEW.column_name IN (datetime('2001-01-01 01:01:01'), datetime('2002-02-02 02:02:02'))",
        message: 'column_name must be included'
      }]) }
    end
  end
end
