require 'spec_helper'
require 'locomotive/models/decorators'

describe Locomotive::Decorators::I18nDecorator do

  class FakeEntity
    include Locomotive::Entity
    attributes :name, :description
  end

  describe 'initialization' do
    context 'with instance' do
      subject do
        Locomotive::Decorators::I18nDecorator.new(FakeEntity.new)
      end

      it 'accepts an entity as parameter' do
        subject.should be_kind_of Locomotive::Decorators::I18nDecorator
      end

      it 'responds to all entity attributes' do
        subject.should respond_to :name
        subject.should respond_to :description
        subject.should respond_to :name=
        subject.should respond_to :description=
      end
    end

    context 'with resultset' do
      let(:entities) {
        [ FakeEntity.new, FakeEntity.new ]
      }
      it 'decorates each entity' do
        Locomotive::Decorators::I18nDecorator.decorate(entities).each do |entity|
          entity.should be_kind_of(Locomotive::Decorators::I18nDecorator)
        end
      end
    end
  end

  describe 'fields on single instance' do

    subject { decorator.name.to_s }
    let(:decorator) { Locomotive::Decorators::I18nDecorator.new(entity) }
    let(:entity) { FakeEntity.new(name: name) }

    context 'when field is not an i18n field' do
      let(:name) { 'blah' }
      it { should eql 'blah' }
    end

    context 'when field is an i18n field' do
      let(:name) { { en: 'blah', fr: 'bla' } }
      context 'no current locale' do
        # TODO redundant test here ( @see fields/i18n_field_spec.rb )
        it 'falls back to default locale' do
          subject.should eql 'blah'
        end
      end

      context 'with current locale' do
        before { decorator.current_locale = :fr }
        it { should eql 'bla' }
      end

      context 'passing current locale in constructor' do
        let(:decorator) { Locomotive::Decorators::I18nDecorator.new(entity, :fr) }
        it { should eql 'bla' }
      end
    end
  end

  describe 'fields on resultset' do
    subject { decorated_set.first.name.to_s }
    let(:entities) {
      [ FakeEntity.new(name: { en: 'blah', fr: 'bla'}),
        FakeEntity.new
      ]
    }
    context 'when no block is given' do
      let(:decorated_set) do
        Locomotive::Decorators::I18nDecorator.decorate(entities)
      end
      it { should eq 'blah' }
    end
    context 'when locale is set in a given block' do
      let(:decorated_set) do
        Locomotive::Decorators::I18nDecorator.decorate(entities, :fr)
      end
      it { should eq 'bla' }
    end
  end
end
