require 'spec_helper'

describe Locomotive::Fields::I18nField do

  subject { Locomotive::Fields::I18nField.new(values) }
  let(:values) { { wk: 'Tik wrzeidl', en: 'My value', es: 'Mi valor' } }
  describe '#to_s' do
    context 'no params' do
      it 'displays object inspection' do
        subject.to_s.should eql '#<Foo: @i18n_values=>{:wk=>Tik wrzeidl,:en=>My value,:es=>Mi valor}>'
      end
    end
    context 'locale as param' do
      it { subject.to_s(:en).should eq 'My value' }
    end
  end

  describe 'alternative access' do
    it { subject.en.should eq 'My value' }
    it { subject[:en].should eq 'My value' }
  end
end
