require 'spec_helper'

describe Locomotive::Adapters::Memory::Dataset do

  let(:john) do
    {
      firstname: 'John',
      lastname: 'Doe',
      email: 'john@example.com',
      age: 24
    }
  end

  let(:jane) do
    {
      firstname: 'Jane',
      lastname: 'Doe',
      email: 'jane@example.com',
      age: 20
    }
  end

  let(:alex) do
    {
      firstname: 'Alex',
      lastname: 'Turam',
      email: 'alex@example.com',
      age: 26
    }
  end

  subject { Locomotive::Adapters::Memory::Dataset.new(:foo) } #(loader) }

  before do
    [john.to_hash, jane.to_hash, alex.to_hash].each do |record|
      subject.create record
    end
  end

  describe '#all' do
    its(:all) { should eq [john.to_hash, jane.to_hash, alex.to_hash] }
  end

  describe '#find' do
    specify do
      expect(subject.find(john[:id])).to eq(john.to_hash)
    end
  end

  describe '#update' do
    before do
      subject.update(jane.to_hash.merge(lastname: 'birkin'))
    end
    specify do
      expect(subject.find(jane[:id]).fetch(:lastname)).to eq('birkin')
    end
  end
end
