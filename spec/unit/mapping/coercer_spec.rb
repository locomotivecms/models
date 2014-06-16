require 'spec_helper'

module Locomotive
  describe Mapping::Coercer do
    include_context 'memory'

    let(:coercer) { Mapping::Coercer.new(mapper.collection(:products)) }

    describe '#to_record' do
      let(:entity) { Example::Product.new entity_hash }

      context 'with locale' do
        subject { coercer.to_record(entity)[:title] }

        context 'when i18n field is localized' do
          let(:entity_hash) {{ title: { en: 'magic vacuum', fr: 'aspirateur magique' }}}

          it { should eq en: 'magic vacuum' , fr: 'aspirateur magique' }
        end

      end

      context 'nil value' do
        subject { coercer.to_record(entity)[:title] }
        let(:entity_hash) { { title: nil } }
        it { should eq({}) }
      end
    end
  end
end
