require 'spec_helper'

describe Locomotive::Repositories::ContentTypeRepository do
  let(:datastore)  { Locomotive::Datastore.new }
  let(:mapper) do
    mapper = Locomotive::Mapper.new do
      collection :content_types do
        entity Locomotive::Entities::ContentType

        attribute :name
        attribute :slug
      end
    end
    mapper.load!
    mapper
  end
  let(:adapter)    { Locomotive::Adapters::MemoryAdapter.new(mapper) }
  let(:repository) { Locomotive::Repositories::ContentTypesRepository.new(datastore, adapter) }

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

      before do
        [content_type, another_content_type].each do |record|
          repository.create(Locomotive::Entities::ContentType.new(record), :en)
        end
      end

      it 'returns the matching content_type' do
        subject.should eq content_type.merge(id: 1)
      end

      describe '#all' do
        specify do expect(repository.all(:en).size).to eq(2) end
        specify do
          expect(repository.all(:en).map(&:name)).to eq(['Content Type 1', 'Content Type 2'])
        end
      end
    end
  end

  describe '#create' do
    let(:new_content_type) do
      Locomotive::Entities::ContentType.new({ name: 'Content Type 3', slug: 'content_type_3' })
    end

    it 'tells the adapter to create the record' do
      expect(adapter).to receive(:create).with(:content_types, new_content_type, :en)
      repository.create(new_content_type, :en)
    end
  end
end
