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

    subject { decorator.name }
    let(:decorator) { Locomotive::Decorators::I18nDecorator.new(entity) }
    let(:entity) { FakeEntity.new(name: name) }

    context 'when field is not an i18n field' do
      let(:name) { 'blah' }
      it { should eql 'blah' }
    end

    context 'when field is an i18n field' do
      let(:name) { { en: 'blah', fr: 'bla' } }
      context 'no current locale' do
        it 'displays object for inspection' do
          subject.should eql '#<I18nField: @i18n_values=>{:en=>blah,:fr=>bla}>'
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
    subject { decorated_set.first.name }
    let(:entities) {
      [ FakeEntity.new(name: { en: 'blah', es: '', fr: 'bla'}),
        FakeEntity.new
      ]
    }
    context 'when no locale is passed in constructor' do
      let(:decorated_set) do
        Locomotive::Decorators::I18nDecorator.decorate(entities)
      end
      it 'displays object for inspection' do
        subject.should eq '#<I18nField: @i18n_values=>{:en=>blah,:es=>,:fr=>bla}>'
      end
    end

    context 'when locale is passed in the constructor' do
      let(:decorated_set) do
        Locomotive::Decorators::I18nDecorator.decorate(entities, :fr)
      end
      it { should eq 'bla' }
    end
  end

  context 'Fallbacks' do
    subject { decorator.name }
    let(:decorator) { Locomotive::Decorators::I18nDecorator.new(entity, locale) }
    let(:entity) { FakeEntity.new(name: name) }
    let(:name) { { en: 'blah', fr: 'bla', es: '' } }

    context 'when passed locale does not exist' do
      let(:locale) { :wk }
      context 'default fallback' do
        it { should be_nil }
      end
      context 'custom fallback' do
        before do
          decorator.on_no_locale = Proc.new { |field, locale| "Translation #{locale} is not supported" }
        end
        it { should eq 'Translation wk is not supported' }
      end
    end

    context 'when entity has empty locale value' do
      let(:locale) { :es }

      context 'default fallback' do
        it 'returns the first locale in the field' do
          subject.should eq 'blah'
        end
      end

      context 'custom fallback' do
        before do
          decorator.on_empty_locale = Proc.new { |field, locale| "#{field[:en]} [untranslated #{locale}]" }
        end
        it { should eq 'blah [untranslated es]' }
      end
    end

  end
end
