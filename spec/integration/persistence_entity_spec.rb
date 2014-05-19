require 'spec_helper'


module Locomotive

  module Entities
    class Dummy
      include Entity
      attributes :name
    end
  end

  describe '' do
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
        repository.create(Entities::Dummy.new({name: 'John Doe'}), locale)
      end
      specify do
        expect(repository.all(locale).size).to eq(1)
      end
    end
  end
end
