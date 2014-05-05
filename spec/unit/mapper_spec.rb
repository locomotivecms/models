require 'spec_helper'

describe Locomotive::Mapper do

  subject do Locomotive::Mapper.new end

  describe '#collection' do

    before do subject.collection(:site) end

    specify do
      expect(
        subject.collections[:site]
      ).to be_instance_of(Locomotive::Mapping::Collection)
    end

    specify do
      expect(
        subject.collections[:site].entity
      ).to be(Locomotive::Entities::Site)
    end
  end
end
