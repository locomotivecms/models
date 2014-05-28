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
      end.load!
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
          repository.create dummy_entity, :en
        end
        specify do
          expect(repository.find(dummy_entity.id, :en).foo).to eq('bar')
        end
      end
    end





    # before do
    #   Models.generate_mapper_for Dummy do
    #     collection :dummies do
    #       entity Dummy
    #       repository DummiesRepository
    #
    #       attribute :foo
    #     end
    #   end
    # end

    # describe '' do
    #   specify do
    #     expect(Models[Dummy]).to eq('')
    #   end
    # end


    # describe '#collection' do
    #   subject { Locomotive::Mapper.new }
    #
    #   context 'setting a collection' do
    #     it 'creates a collection' do
    #       subject.collection(:new_collection) {}
    #       subject.collections[:new_collection].should be_an_instance_of Locomotive::Mapping::Collection
    #     end
    #   end
    #
    #   context 'getting a collection' do
    #     context 'when it is not set' do
    #       it 'raises an error' do
    #         expect {
    #           subject.collection(:foo)
    #         }.to raise_error Locomotive::Mapping::UnmappedCollectionError
    #       end
    #     end
    #
    #     context 'when it is already set' do
    #       before { subject.instance_variable_set(:"@collections", new_collection: 'a col' ) }
    #
    #       it 'returns the existing collection' do
    #         subject.collection(:new_collection).should eq 'a col'
    #       end
    #     end
    #   end
    # end
    #
    # describe '#load' do
    #   let(:file) { File.expand_path('../../fixtures/example_mapper.rb', __FILE__) }
    #   subject { Locomotive::Mapper.load_from_file! file }
    #
    #   it { should be_an_instance_of(Locomotive::Mapper) }
    #
    #   it 'loads the collections' do
    #     subject.collections.size.should eq 4
    #     subject.collection(:articles).should be_an_instance_of Locomotive::Mapping::Collection
    #   end
    # end
  end
end
