require 'spec_helper'

describe Locomotive::Entity do
  class FakeEntity < Locomotive::Entity; end

  subject { FakeEntity.new }

  describe '#to_record' do
    it 'returns a hash' do
      subject.to_record.should be_kind_of Hash
    end
  end
end
