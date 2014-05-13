require 'spec_helper'

describe Locomotive::Entity do
  let(:attributes) {{ mounting_point: nil, name: 'bar' }}

  class FakeEntity < Locomotive::Entity
    field :name
  end

  subject { FakeEntity.new(attributes) }

  describe '#to_record' do
    it 'returns an entity' do
      subject.to_record.should eq({name: 'bar'})
    end
  end
end
