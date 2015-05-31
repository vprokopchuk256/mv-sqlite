require 'spec_helper'

RSpec.describe 'regexp extension' do
  context 'not matched' do
    let(:db) { ActiveRecord::Base.connection }

    it 'return position if matched and -1 if not matched' do
      expect(db.select_values("SELECT 'efg' REGEXP '^abc$'")).to eq([0])
      expect(db.select_values("SELECT 'abc' REGEXP '^abc$'")).to eq([1])
    end
  end
end
