require 'spec_helper'
require 'fixtures/example_entities'

describe Locomotive::Mapper do
  describe '#collection' do
    subject { Locomotive::Mapper.new }

    context 'setting a collection' do
      it 'creates a collection' do
        subject.collection(:new_collection) {}
        subject.collections[:new_collection].should be_an_instance_of Locomotive::Mapping::Collection
      end
    end

    context 'getting a collection' do
      context 'when it is not set' do
        it 'raises an error' do
          expect {
            subject.collection(:foo)
          }.to raise_error Locomotive::Mapping::UnmappedCollectionError
        end
      end

      context 'when it is already set' do
        before { subject.instance_variable_set(:"@collections", new_collection: 'a col' ) }

        it 'returns the existing collection' do
          subject.collection(:new_collection).should eq 'a col'
        end
      end
    end
  end

  describe '#load' do
    let(:file) { File.expand_path('../../fixtures/example_mapper.rb', __FILE__) }
    subject { Locomotive::Mapper.load_from_file! file }

    it { should be_an_instance_of(Locomotive::Mapper) }

    it 'loads the collections' do
      subject.collections.size.should eq 4
      subject.collection(:articles).should be_an_instance_of Locomotive::Mapping::Collection
    end
  end
end
