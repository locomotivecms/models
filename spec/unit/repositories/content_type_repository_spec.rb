require 'spec_helper'

describe Locomotive::Repositories::ContentTypeRepository, pending: true do
  let(:datastore)  { Locomotive::Datastore.new }
  let(:adapter)    { Locomotive::Adapters::MemoryAdapter.new }
  let(:repository) { Locomotive::Repositories::ContentTypeRepository.new(datastore, adapter) }

  describe '#find_by_name' do
    let(:name) { /Content Type/ }

    subject { repository.find_by_name(name) }

    context 'no content_types' do
      it 'returns none' do
        subject.should eq nil
      end
    end

    context 'with content_types' do
      let(:content_type)         {{ name: 'Content Type 1', slug: 'content_type_1' }}
      let(:another_content_type) {{ name: 'Content Type 2', slug: 'content_type_2' }}
      let(:content_types)        { Locomotive::Adapters::Memory::Dataset.new([content_type, another_content_type]) }

      before do
        expect(adapter).to receive(:dataset).with(:content_type) { content_types }
      end

      it 'returns the matching content_type' do
        subject.should eq content_type
      end

      describe '#all' do
        specify do expect(repository.all.size).to eq(2) end
        specify do
          expect(repository.all.map(&:name)).to eq(['Content Type 1', 'Content Type 2'])
        end
      end
    end
  end

  describe '#create' do
    let(:new_content_type) {{ name: 'Content Type 3', slug: 'content_type_3' }}

    it 'tells the adapter to create the record' do
      expect(adapter).to receive(:create).with(:content_type, new_content_type)
      repository.create(new_content_type)
    end
  end
end
