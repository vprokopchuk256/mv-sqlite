require 'spec_helper'

require 'mv/sqlite/validation/builder/trigger/presence'

describe Mv::Sqlite::Validation::Builder::Trigger::Presence do
  def presence(opts = {})
    Mv::Core::Validation::Presence.new(:table_name,
                                       :column_name,
                                        { message: 'must be present' }.merge(opts))
  end

  describe "#conditions" do
    subject { described_class.new(presence(opts)).conditions }

    describe "by default" do
      let(:opts) { {} }

      it { is_expected.to eq([{
        statement: "NEW.column_name IS NOT NULL AND LENGTH(TRIM(NEW.column_name)) > 0",
        message: 'column_name must be present'
      }]) }
    end
  end
end
