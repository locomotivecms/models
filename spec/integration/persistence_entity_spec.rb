require 'spec_helper'


module Locomotive

  module Entities
    class Dummy
      include Entity
      attributes :name
    end
  end


  describe '' do
    let(:entity) { Entities::Dummy.new({name: 'John Doe'}) }
    
    let(:repository) do
      class DummyRepository
        include Repository
      end.new(datastore, adapter, locale)
    end
    let(:datastore) { Locomotive::Datastore.new }
    let(:adapter)   { Locomotive::Adapters::MemoryAdapter.new(mapper) }
    let(:locale)    { :en }
    let(:mapper) do
      Locomotive::Mapper.new do
        collection :dummy, :en do
          entity Entities::Dummy
          attribute :name, localized: true
        end
      end
    end

    describe 'write an entity' do
      before do
        repository.create(entity, locale)
      end
      specify do
        expect(repository.all(locale).size).to eq(1)
      end
      it 'gives an ID to the entity' do
        entity.id.should_not be_nil        
      end
    end

    describe 'finding an entity by its ID' do
      context 'when entity exists' do
        before  { repository.create(entity, locale) }
        subject { repository.find(entity.id) }

        it { should be_kind_of Entities::Dummy }
        its(:id) { should_not be_nil }
      end

      context 'when entity could not be found' do
        subject { repository.find(1234) }
        it 'raises an error' do
          expect { subject }.to raise_error Repository::RecordNotFound, 'could not find dummy with id = 1234'
        end
      end
    end

    describe 'update an entity' do
      before do
        repository.create(entity, locale)
        entity.name= 'Jane Doe'
        repository.update(entity, locale)
      end

      it 'does not create a new record' do
        expect(repository.all(locale).size).to eq(1)
      end
    end

    describe 'destroying an entity' do
      before  { repository.create(entity, locale) }
      it 'destroys an entry' do
        repository.destroy(entity)
        expect(repository.all(locale).size).to eq(0)
      end

    end
  end
end
