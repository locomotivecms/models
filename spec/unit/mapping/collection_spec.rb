require 'spec_helper'

describe Locomotive::Mapping::Collection, pending: true do

  subject do Locomotive::Mapping::Collection.new(:site) end

  describe '#deserialize' do
    let(:records) { [{name: 'foo'}] }

    specify do
      expect(subject.deserialize(records).size).to eq(1)
    end

    specify do
      expect(subject.deserialize(records).first).to be_instance_of(Locomotive::Entities::Site)
    end

    specify do
      expect(subject.deserialize(records).first.name).to eq('foo')
    end
  end
end
