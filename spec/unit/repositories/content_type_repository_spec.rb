require 'spec_helper'
require 'ostruct'

describe Locomotive::Repositories::SiteRepository do
  let(:datastore)  { Locomotive::Datastore.new }
  let(:adapter)    { Locomotive::Adapters::MemoryAdapter.new }
  let(:repository) { Locomotive::Repositories::ContentTypesRepository.new(datastore, adapter) }

  context 'with content types' do
    let(:content_type) { OpenStruct.new(name: 'Bands', description: 'List of bands') }
    let(:content_types) { Locomotive::Adapters::Memory::Dataset.new([content_type]) }

    before do
      expect(adapter).to receive(:dataset).with(:content_types) { content_types }
    end

    describe '#all' do
      specify do expect(repository.all.size).to eq(1) end
      specify do
        expect(repository.all.map(&:name)).to eq(['Bands'])
      end
    end
  end
end
