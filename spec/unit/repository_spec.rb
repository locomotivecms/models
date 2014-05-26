require 'spec_helper'

describe Locomotive::Repository do

  class DummyRepository
    include Locomotive::Repository
  end

  class DummyEntity
    include Locomotive::Entity
  end

  let(:repository) { DummyRepository.new(datastore, adapter) }
  let(:datastore) { double }
  let(:adapter) { double }

  describe '#persisted?' do
    subject { repository.persisted? entity }

    context 'entity with no id' do
      let(:entity) { DummyEntity.new }
      it { should be_false }
    end

    context 'entity with id' do
      let(:entity) { DummyEntity.new(id: 'i_have_an_ID') }
      before { adapter.should_receive(:persisted?).with(:dummy, entity).and_return true }
      it 'asks the adapter' do
        subject.should be_true
      end
    end
  end
end
