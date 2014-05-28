require 'spec_helper'

module Locomotive
  describe Mapping::Collection do
    let(:mapper) { double }

    subject do
      collecion = Mapping::Collection.new(mapper, :site, Mapping::Coercer) do
        entity Entities::Site
      end
      collecion.load!
      collecion
    end

    describe '#deserialize' do
      let(:records) { [{name: 'foo'}] }

      specify do
        expect(subject.deserialize(records, :en).size).to eq(1)
      end

      specify do
        expect(subject.deserialize(records, :en).first).to be_instance_of(Entities::Site)
      end
    end
  end
end
