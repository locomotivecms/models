require 'spec_helper'

describe Locomotive::Presenters::Base do
  let(:class_with_localized_field) do
    Class.new do
      include Locomotive::Fields
      field :name, localized: true
    end
  end

  describe '#to_hash' do
    let(:entity)  { class_with_localized_field.new attributes }
    let(:context) { nil }
    let(:attributes) { { name: { en: 'John Doe', fr: 'Jean Daux' } } }
    subject { Locomotive::Presenters::Base.new(entity, context) }

    context 'with no locale defined in context' do
      it 'returns all the translations' do
        expect(subject.to_hash).to eq 'name' => { 'en' => 'John Doe', 'fr' => 'Jean Daux' }
      end
    end

    context 'with current locale defined in context' do
      let(:attributes) { { name: { en: 'John Doe', fr: 'Jean Daux' } } }
      let(:context) { OpenStruct.new(locale: :fr) }
      it 'flattens and returns the localized value' do
        expect(subject.to_hash).to eq 'name' => 'Jean Daux'
      end
    end
  end
end
