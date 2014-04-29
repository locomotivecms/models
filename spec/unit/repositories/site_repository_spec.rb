require 'spec_helper'
require 'ostruct'

describe Locomotive::Repositories::SiteRepository do
  let(:datastore)  { Locomotive::Datastore.new }
  let(:adapter)    { Locomotive::Adapters::MemoryAdapter.new }
  let(:repository) { Locomotive::Repositories::SiteRepository.new(datastore, adapter) }

  describe '.find_by_host' do
    let(:host) { 'www.acme.org' }

    subject { repository.find_by_host(host) }

    context 'no sites' do

      it 'returns none' do
        subject.should eq nil
      end
    end

    context 'with sites' do
      let(:site)         { OpenStruct.new(name: 'Acme', domains: ['www.acme.org']) }
      let(:another_site) { OpenStruct.new(name: 'Acme', domains: ['www.acme.com']) }
      let(:sites)        { Locomotive::Adapters::Memory::Dataset.new([site, another_site]) }

      before do
        expect(adapter).to receive(:dataset).with(:site) { sites }
      end

      it 'returns the matching site' do
        subject.should eq site
      end

      describe '#load' do
        specify do
          expect(repository.load.size).to eq(2)
        end
      end
    end
  end

end
