require 'spec_helper'

describe Locomotive::Datastore do

  let(:path)      { File.expand_path('../../fixtures/default', __FILE__) }
  let(:loader)    { Locomotive::Adapters::Memory::YamlLoader.new(path) }
  let(:adapter)   { Locomotive::Adapters::MemoryAdapter.new(loader) }
  let(:datastore) { Locomotive::Datastore.new(adapter: adapter) }

  describe 'mounting point' do

    subject { datastore.build_mounting_point('www.example.com') }

    it 'gets a site', pending: true do
      subject.site.name.should eq 'Sample website'
    end

  end

end