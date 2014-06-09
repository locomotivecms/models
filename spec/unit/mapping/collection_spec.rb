require 'spec_helper'

module Locomotive

  describe Mapping::Collection do
    let(:mapper) { double }

    module Example
      class Foo
        include Locomotive::Entity
      end
    end

    subject do
      Mapping::Collection.new(mapper, :site, Mapping::Coercer) do
        entity Example::Foo
      end
    end

    describe '#deserialize' do
      let(:records) { [{name: 'foo'}] }

      specify do
        expect(subject.deserialize(records).size).to eq(1)
      end

      specify do
        expect(subject.deserialize(records).first).to be_instance_of(Example::Foo)
      end
    end
  end
end
