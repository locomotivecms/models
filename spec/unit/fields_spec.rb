require 'spec_helper'

describe Locomotive::Fields do
  let(:anonyme_class) do
    Class.new do
      include Locomotive::Fields
      field :name, localized: true
      field :published, default: true
    end
  end

  describe '.fields' do
    let(:fields) {{ name: { localized: true }, published: { localized: false, default: true }}}
    specify do
      expect(anonyme_class._fields).to eq(fields)
    end
  end

  context 'instance' do
    let(:entity) { anonyme_class.new attributes }

    context 'with no I18n attributes defined' do
      let(:attributes) {{  }}
      describe '#_locales' do
        specify do
          expect(entity.send(:_locales)).to eq([])
        end
      end
    end
    context 'with no I18n attributes defined' do
      let(:attributes) {{ name: { en: 'John Doe' } }}
      describe '#_locales' do
        specify do
          expect(entity.send(:_locales)).to eq([:en])
        end
      end
      describe '#to_hash' do
        specify do
          expect(entity.to_hash).to eq({ 'name' => { 'en' => 'John Doe' }, 'published' => true })
        end
      end
    end

    context 'localized field defined process' do
      let(:attributes) {{ name: name }}
      context 'regular way' do
        let(:name) do
          FieldValue = Struct.new(:name) do
            def to_hash() { en: self.name } ; end
          end.new('John Doe')
        end
        specify do
          expect(entity.name).to eq({ en: 'John Doe' })
        end
      end
    end

    context 'with several translations' do
      let(:values) {{ en: 'Mister John Doe', fr: 'Monsieur John Doe' }}
      let(:attributes) {{ name: values }}

      specify do expect(entity.name).to eq(values) end
      specify do
        expect(entity.attributes).to eq({ name: values, published: true })
      end

      context 'add new translation with existing' do
        let(:another_values) {{ wk: 'Wyaaaaaa John Doe' }}
        specify do
          expect(entity.name).to eq({ en: 'Mister John Doe', fr: 'Monsieur John Doe' })
          entity.name = another_values #.fetch(:wk)
          expect(entity.name).to eq(
            { en: 'Mister John Doe', fr: 'Monsieur John Doe', wk: 'Wyaaaaaa John Doe' }
          )
          expect(entity.send(:_locales)).to eq([:en, :fr, :wk])
        end
      end
    end
  end
end
