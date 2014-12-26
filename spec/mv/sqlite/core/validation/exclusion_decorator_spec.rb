require 'spec_helper'

require 'mv/core/validation/exclusion'
require 'mv/sqlite/core/validation/exclusion_decorator'

describe Mv::Sqlite::Core::Validation::ExclusionDecorator do
  before do
    Mv::Core::Validation::Exclusion.send(:prepend, described_class)
  end

  subject { Mv::Core::Validation::Exclusion.new(:table_name, :column_name, in: [1, 2], as: :check) }

  it { is_expected.to be_invalid }
end