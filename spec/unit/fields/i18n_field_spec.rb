require 'spec_helper'

describe Locomotive::Fields::I18nField do

  subject { Locomotive::Fields::I18nField.new(values) }
  let(:values) { { wk: '', en: 'My value', es: 'Mi valor' } }
  describe '#to_s' do
    context 'no params' do
      it 'displays object inspection' do
        subject.to_s.should eql '#<I18nField: @i18n_values=>{:wk=>,:en=>My value,:es=>Mi valor}>'
      end
    end
    context 'locale as param' do
      it { subject.to_s(:en).should eq 'My value' }
    end
    context 'non existing locale as param' do
      it 'raises an error' do
        expect{ subject.to_s(:kz) }.to raise_error(Locomotive::Fields::I18nField::NoLocaleError)
      end
    end
    context 'empty translation' do
      it 'raises an error' do
        expect{ subject.to_s(:wk) }.to raise_error(Locomotive::Fields::I18nField::EmptyLocaleError)
      end
    end
  end

  describe 'alternative access' do
    it { subject.en.should eq 'My value' }
    it { subject[:en].should eq 'My value' }
  end

  describe 'adding values' do
    subject { Locomotive::Fields::I18nField.new(values) }
    let(:values) { { en: 'My value' } }
    before { subject << new_values }

    context 'hash with string keys' do
      let(:new_values) { {'fr' => 'Valeur'} }
      it { subject.fr.should eq 'Valeur' }
    end

    context 'hash with symbol keys' do
      let(:new_values) { {fr: 'Valeur'} }
      it { subject.fr.should eq 'Valeur' }
    end
  end
end
