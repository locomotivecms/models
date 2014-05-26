require 'spec_helper'

describe Locomotive::Adapters::MemoryAdapter, pending: true do
  let(:adapter)   { Locomotive::Adapters::MemoryAdapter.new(mapper) }

  let(:mapper) do
    Locomotive::Mapper.new do
      collection :dummy, :en do
        entity Entities::Dummy
        attribute :name, localized: true
      end
    end
  end

  subject { adapter }

  context 'with no loader' do

    it 'gets an empty set of sites' do
      subject.size(:site).should eq 0
    end
  end

  describe '#exists?', pending: 'TODO' do
  end

end
