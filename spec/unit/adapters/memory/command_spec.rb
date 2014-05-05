require 'spec_helper'

describe Locomotive::Adapters::Memory::Command do
  let(:loader)     { double(to_a: []) }
  let(:dataset)    { Locomotive::Adapters::Memory::Dataset.new(loader) }
  let(:collection) { :site }

  subject do Locomotive::Adapters::Memory::Command.new(dataset, collection) end

  describe '#create' do
    let(:entity) { Locomotive::Entities::Site.new({ name: 'foo' }) }

    before do subject.create(entity) end

    specify do
      expect(dataset.all.size).to eq(1)
    end

    specify do
      expect(dataset.all.first).to be_instance_of(Locomotive::Entities::Site)
    end

    specify do
      expect(dataset.all.first.name).to eq('foo')
    end
  end
end
