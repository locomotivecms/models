require 'spec_helper'
# require 'fixtures/example_entities'

module Locomotive

  describe Mapper do

    class Dummy
      include Entity
      attributes :foo
    end

    class DummiesRepository
      include Repository
    end

    let(:adapter) do
      Locomotive::Adapters::MemoryAdapter
    end

    let!(:mapper) do
      Mapper.new(adapter) do
        collection :dummies do
          entity Dummy
          repository DummiesRepository

          attribute :foo
        end
      end
    end

    describe '' do
      before do mapper end
      specify do
        expect(Models.mapper).to be_a Mapper
      end
      specify do
        expect(Models.mapper.collection(:dummies)).to be_a Mapping::Collection
      end
      specify do
        expect(Models.mapper.collection(:dummies).repository).to be_a Locomotive::DummiesRepository
      end

      context '' do
        let(:dummy_entity) do
          Dummy.new({ foo: 'bar' })
        end
        let(:repository) do
          Models.mapper.collection(:dummies).repository
        end
        before do
          repository.create dummy_entity
        end
        specify do
          expect(repository.find(dummy_entity.id).foo).to eq('bar')
        end
      end
    end
  end
end
