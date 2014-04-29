require 'spec_helper'

describe Locomotive::Adapters::MemoryAdapter do
  let(:loader)  { nil }
  let(:adapter) { Locomotive::Adapters::MemoryAdapter.new(loader) }

  subject { adapter }

  context 'with no loader' do

    it 'gets an empty set of sites' do
      subject.size(:site).should eq 0
    end
  end

  context 'with a YAML loader' do
    let(:loader) { Locomotive::Adapters::Memory::YamlLoader.new('somewhere') }

    before do allow(loader.get(:site)).to receive(:to_a) { [{ name: 'Acme' }] } end

    it 'returns a single site' do
      subject.size(:site).should eq 1
    end

    context '' do
      let(:entity) { Locomotive::Entities::Site.new({ name: 'my awesome site'}) }
      before do adapter.create :site, entity end
      specify do expect(adapter.size(:site)).to eq(2) end
      specify do
        expect(adapter.all(:site).map(&:name)).to eq(['Acme', 'my awesome site'])
      end
    end
  end
end
