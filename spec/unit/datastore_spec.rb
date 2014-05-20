require 'spec_helper'

describe Locomotive::Datastore do

  let(:datastore) { Locomotive::Datastore.new }

  describe 'mounting point' do

    subject { datastore.build_mounting_point('www.example.com') }

    it 'keeps a reference of the datastore' do
      subject.datastore.should eq datastore
    end

    it 'gets a site' do
      subject.site.should eq nil
    end

  end

  describe 'options' do
    context 'setting custom mapper' do
      subject { Locomotive::Datastore.new(mapper: 'a custom mapper') }
      it 'uses the mapper from options' do
        subject.mapper.should eq 'a custom mapper'
      end
    end
    context 'default mapper' do
      subject { Locomotive::Datastore.new }

      it 'uses the built in mapper' do
        subject.mapper.collection(:site).should_not be_nil
      end
    end
  end

end
