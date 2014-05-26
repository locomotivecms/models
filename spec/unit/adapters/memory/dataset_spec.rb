require 'spec_helper'

describe Locomotive::Adapters::Memory::Dataset, pending: true do


  let(:john) {
    OpenStruct.new firstname: 'John',
                   lastname: 'Doe',
                   email: 'john@example.com',
                   age: 24
  }
  let(:jane) {
    OpenStruct.new firstname: 'Jane',
                   lastname: 'Doe',
                   email: 'jane@example.com',
                   age: 20
  }

  let(:alex) {
    OpenStruct.new firstname: 'Alex',
                   lastname: 'Turam',
                   email: 'alex@example.com',
                   age: 26
  }

  let(:base_items) { [john, jane, alex] }
  let(:loader) { base_items }

  subject { Locomotive::Adapters::Memory::Dataset.new(loader) }

  describe '#all' do
    its(:all) { should eq base_items }
  end

  context 'filtering items' do

    context '#where' do
      it 'simple key value pair' do
        subject.where('lastname' => 'Doe').should eq [john, jane]
      end

      it 'multiple key value pair' do
        subject.where('firstname' => 'John', 'lastname' => 'Doe').should eq [john]
      end

      it 'unkown key returns empty resultset' do
        subject.where('fake' => 'Key').should eq []
      end
      it 'symbolized keys' do
        subject.where(firstname: 'John').should eq [john]
      end

      it 'gt' do
        subject.where('age.gt' => 21).should eq [john, alex]
      end

      it 'lt' do
        subject.where('age.lt' => 21).should eq [jane]
      end

      it 'in' do
        subject.where('firstname.in' => ['John','Jane']).should eq [john, jane]
      end
    end

    context '#order_by' do
      it 'default is ASC' do
        subject.order_by('firstname asc').first.should eq alex
      end

      it 'desc' do
        subject.order_by('firstname desc').first.should eq john
      end

      it 'direction is case insensitive' do
        subject.order_by('firstname DESC').first.should eq john
        subject.order_by('firstname ASC').first.should eq alex
      end
    end

    context '#limit' do
      it 'returns empty if 0 specified as param' do
        subject.limit(0).size.should eq 0
      end

      it 'returns the number of items specified as param' do
        subject.limit(2).size.should eq 2
      end

      it 'returns at most the existing items' do
        subject.limit(10).size.should eq 3
      end

    end

    context '#offset' do
      it 'returns the nth records' do
        subject.order_by('age ASC').offset(1).should eq [john, alex]
      end
      it 'with limit it returns a slice' do
        subject.order_by('age ASC').limit(1).offset(1).should eq [john]
        subject.order_by('age ASC').limit(1).offset(2).should eq [alex]
      end
    end
    context 'chaining' do
      it 'multiple wheres' do
        subject.where('lastname' => 'Doe').where('firstname' => 'John').should eq [john]
      end

      it 'where and order_by' do
        subject.where('lastname' => 'Doe').order_by('firstname ASC').first.should eq jane
        subject.where('lastname' => 'Doe').order_by('firstname DESC').first.should eq john
      end

      it 'where and limit' do
        subject.limit(1).where('lastname' => 'Doe').order_by('firstname ASC').should eq [jane]
      end

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
