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
      subject.insert record
    end
  end

  describe '#all' do
    its(:all) { should eq [john.to_hash, jane.to_hash, alex.to_hash] }
  end

  describe '#find' do
    specify do
      expect(subject.find(john[:id], :en)).to eq(john.to_hash)
    end
  end

  describe '#update' do
    before do
      subject.update(jane.to_hash.merge(lastname: 'birkin'))
    end

    specify do
      expect(subject.find(jane[:id], :en).fetch(:lastname)).to eq('birkin')
    end
  end

  describe '#exists?' do
    let(:dataset) { Locomotive::Adapters::Memory::Dataset.new(:dummy) }
    before do
      dataset.instance_variable_set('@records', { 1 => 'Record 1', 2 => 'Record 2' })
    end

    it { dataset.exists?(2).should   be_true  }
    it { dataset.exists?(3).should   be_false }
    it { dataset.exists?(nil).should be_false }

  end
end
