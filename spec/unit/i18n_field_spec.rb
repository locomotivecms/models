require 'spec_helper'

describe Locomotive::I18nField do

  context 'with translation on initialization process' do
    let(:translations) {{ en: 'Welcome' }}

    subject do Locomotive::I18nField.new translations end

    specify do
      expect(subject.translations).to eq(translations)
    end
    specify do
      expect(subject.to_s).to eq('Welcome')
    end
    specify do
      expect(subject.value = {fr: 'Bonjour'}).to eq({ fr: 'Bonjour' })
      expect(subject.translations).to eq({ en: 'Welcome', fr: 'Bonjour' })
      expect(subject.to_hash).to eq({ en: 'Welcome', fr: 'Bonjour' })
      expect(subject.locales).to eq([:en, :fr])
      expect(subject.to_s).to eq('Welcome')
      expect(subject.to_s(:en)).to eq('Welcome')
      expect(subject.to_s(:fr)).to eq('Bonjour')
    end
  end

  context 'with translation defined on value' do
    let(:translations) {{ en: 'Welcome' }}

    subject do Locomotive::I18nField.new end

    before do
      subject.value = { en: 'Welcome' }
    end

    specify do
      expect(subject.translations).to eq(translations)
    end
    specify do
      expect(subject.to_s).to eq('Welcome')
    end
    specify do
      expect(subject.to_s(:en)).to eq('Welcome')
    end
  end
end
