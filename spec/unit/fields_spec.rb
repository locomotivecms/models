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
    let(:attributes) {{}}
    let(:entity) { anonyme_class.new attributes }

    describe '#_locales' do
      specify do
        expect(entity._locales).to eq([:en])
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
          expect(entity.name).to eq('John Doe')
        end
      end

      # TODO I'm not agree with this approach
      context 'bad way' do
        let(:name) { 'John Doe' }
        specify do
          expect(entity.name).to eq('John Doe')
        end
        specify do
          expect(Locomotive::Models.locale).to eq(:en)
        end
        context '.with_locale' do
          before { entity }
          specify do
            Locomotive::Models.with_locale(:en) do
              expect(entity.name).to eq('John Doe')
            end
          end
          specify do
            Locomotive::Models.with_locale(:fr) do
              expect(entity.name).to be_nil
            end
          end
        end
      end
    end

    context 'should can pass any object with .to_hash contract' do
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

    context 'with several translations' do
      let(:values) {{ en: 'Mister John Doe', fr: 'Monsieur John Doe' }}
      let(:attributes) {{ name: values }}

      specify do expect(entity.name).to eq('Mister John Doe') end
      specify do expect(entity.name_translations).to eq(values) end
      specify do
        expect(entity.instance_variable_get(:@name).translations).to eq(values)
      end
      specify do
        expect(entity.attributes).to eq({name:'Mister John Doe', published: true})
      end
      specify do
        expect(entity.attributes_with_translations).to eq({name: values, published: true})
      end

      context '.with_locale' do
        specify do
          Locomotive::Models.with_locale(:en) do
            expect(entity.name).to eq('Mister John Doe')
          end
        end
        specify do
          Locomotive::Models.with_locale(:fr) do
            expect(entity.name).to eq('Monsieur John Doe')
          end
        end
      end

      context 'add new translation with existing' do
        let(:another_values) {{ wk: 'Wyaaaaaa John Doe' }}
        specify do
          expect(entity.name_translations).to eq({ en: 'Mister John Doe', fr: 'Monsieur John Doe' })
          expect(Locomotive::Models.locale).to eq(:en)
          expect(entity.name).to eq('Mister John Doe')
          entity.name = another_values #.fetch(:wk)
          expect(entity.name_translations).to eq(
            { en: 'Mister John Doe', fr: 'Monsieur John Doe', wk: 'Wyaaaaaa John Doe' }
          )
          expect(entity.name).to eq('Mister John Doe')
          expect(entity.instance_variable_get(:@name).translations).to eq(values.merge(another_values))
          expect(entity._locales).to eq([:en, :fr, :wk])
        end
      end
    end

    context '#attributes_with_translations' do
      let(:values) {{ en: 'Mister John Doe' }}
      let(:attributes) {{ name: values }}
      specify do
        expect(entity.attributes_with_translations).to eq({ name: values[:en], published: true })
      end
    end
  end
end
