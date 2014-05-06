require 'spec_helper'

describe Locomotive::Fields, pending: true do
  let(:anonyme_class) do
    Class.new do
      include Locomotive::Fields
      field :name, localized: true
      field :published, default: true
    end
  end
  let(:fields) {{ name: { localized: true }, published: { localized: false, default: true }}}
  let(:attributes) {{}}

  describe '.fields' do
    specify do
      expect(anonyme_class._fields).to eq(fields)
    end
  end

  context 'instance' do
    let(:entity) { anonyme_class.new attributes }

    describe '#_locales' do
      specify do
        expect(entity._locales).to eq([:en])
      end
    end

    context '' do
      let(:name) do
        FieldValue = Struct.new(:name) do
          def to_hash() { en: self.name } ; end
        end.new('John Doe')
      end
      let(:attributes) {{ name: name }}
      specify do
        expect(entity.name).to eq('John Doe')
      end
    end

    context '' do
      let(:values) {{ en: 'Mister John Doe', fr: 'Monsieur John Doe' }}
      let(:attributes) {{ name: values }}

      specify do
        expect(entity.name).to eq('Mister John Doe')
      end
      specify do
        expect(entity.name_translations).to eq(values)
      end
      specify do
        expect(entity.instance_variable_get(:@name)).to eq(values)
      end
      specify do
        expect(entity.attributes).to eq({name:'Mister John Doe', published: true})
      end
      specify do
        expect(entity.attributes_with_translations).to eq({name: values, published: true})
      end

      context '' do #, focused: true do
        let(:another_values) {{ wk: 'Wyaaaaaa John Doe' }}
        specify do
          expect(entity.name).to eq('Mister John Doe')
          entity.name = another_values
          expect(entity.name).to eq('Mister John Doe')
          expect(entity.instance_variable_get(:@name)).to eq(values.merge(another_values))
          expect(entity._locales).to eq([:en, :fr, :wk])
        end
      end
    end

    context '' do
      let(:values) {{ en: 'Mister John Doe' }}
      let(:attributes) {{ name: values }}

      specify do
        expect(entity.attributes_with_translations).to eq({name: values, published: true})
      end
    end
  end
end
