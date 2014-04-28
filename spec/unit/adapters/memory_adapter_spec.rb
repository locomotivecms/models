require 'spec_helper'

describe Locomotive::Adapters::MemoryAdapter do

  let(:loader) { nil }

  let(:adapter) { Locomotive::Adapters::MemoryAdapter.new(loader) }

  subject { adapter }

  context 'with no loader' do

    it 'gets an empty set of sites' do
      subject.size(:site).should eq 0
    end

  end

  context 'with a YAML loader' do

    let(:loader) { Locomotive::Adapters::Memory::YamlLoader.new('somewhere') }

    before do
      loader.get(:site).expects(:to_a).returns(['Acme'])
    end

    it 'returns a single site' do
      subject.size(:site).should eq 1
    end

  end

end