require 'spec_helper'

describe Locomotive::Datastore, pending: true do

  let(:datastore) { Locomotive::Datastore.new(attr1: 42, attr2: 'Lorem ipsum') }

  describe 'mounting point' do

    subject { datastore.build_mounting_point('www.example.com') }

    it 'keeps a reference of the datastore' do
      subject.datastore.should eq datastore
    end

    it 'gets a site' do
      subject.site.should eq nil
    end
  end
end
