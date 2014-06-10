require 'spec_helper'

describe Locomotive::Fields::I18nField do

  subject { Locomotive::Fields::I18nField.new(values, locale) }
  let(:values) { { wk: 'Tik wrzeidl', en: 'My value', es: 'Mi valor' } }
  let(:locale) { nil }
  describe '#to_s' do

    context 'when no current locale is set' do
      let(:locale) { nil }
      it 'falls back to first value in hash' do
        subject.to_s.should eql 'Tik wrzeidl'
      end
    end

    context 'when current locale set' do
      let(:locale) { :en }
      it { subject.to_s.should eql 'My value' }
    end
  end

  describe 'alternative access' do
    it { subject.en.should eq 'My value' }
    it { subject[:en].should eq 'My value' }
    it { subject.to_s(:en).should eq 'My value' }
  end
end
