require 'spec_helper'

describe Locomotive::MountingPoint do

  let(:path)      { File.expand_path('../../fixtures/default', __FILE__) }
  let(:loader)    { Locomotive::Adapters::Memory::YamlLoader.new(path) }
  let(:adapter)   { Locomotive::Adapters::MemoryAdapter.new(loader) }
  let(:datastore) { Locomotive::Datastore.new(adapter: adapter) }

  subject do
    Locomotive::MountingPoint.new(datastore, 'sample.example.com')
  end

  context '' do
    specify { expect(subject.site).to_not be_nil }
    specify { expect(subject.site['name']).to eq('Sample website') }
  end

end
