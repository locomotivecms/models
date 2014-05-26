require 'spec_helper'

module Locomotive
  describe Mapping::Collection do

    subject do
      collection = Mapping::Collection.new(:site, Mapping::Coercer) do
        entity Entities::Site
      end
      collection.load!
      collection
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
