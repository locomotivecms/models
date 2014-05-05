require 'spec_helper'

describe Locomotive::Entity do
  class FakeEntity < Locomotive::Entity
    def self.attributes() [ :foo ] ; end
    attr_accessor *self.attributes
  end

  subject { FakeEntity.new({foo: 'bar'}) }

  describe '#to_record' do
    it 'returns a hash' do
      subject.to_record.should be_kind_of Hash
    end
  end
end
