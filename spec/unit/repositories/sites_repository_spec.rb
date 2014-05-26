require 'spec_helper'

describe Locomotive::Repositories::SiteRepository do
  let(:datastore)  { Locomotive::Datastore.new }
  let(:mapper) do
    mapper = Locomotive::Mapper.new do
      collection :sites do
        entity Locomotive::Entities::Site

        attribute :name
        attribute :domains
      end
    end
    mapper.load!
    mapper
  end
  let(:adapter)    { Locomotive::Adapters::MemoryAdapter.new(mapper) }
  let(:repository) { Locomotive::Repositories::SitesRepository.new(datastore, adapter) }

  describe '#find_by_host' do
    let(:host) { 'www.acme.org' }

    subject { repository.find_by_host(host) }

    context 'no sites' do
      it 'returns none' do
        subject.should eq nil
      end
    end

    context 'with sites' do
      let(:site)         {{ name: 'Acme 1', domains: ['www.acme.org'] }}
      let(:another_site) {{ name: 'Acme 2', domains: ['www.acme.com'] }}

      before do
        [site, another_site].each do |record|
          repository.create(Locomotive::Entities::Site.new(record), :en)
        end
      end

      it 'returns the matching site' do
        subject.should eq site.merge(id: 1)
      end

      describe '#all' do
        specify do expect(repository.all(:en).size).to eq(2) end
        specify do
          expect(repository.all(:en).map(&:name)).to eq(['Acme 1', 'Acme 2'])
        end
      end
    end
  end

  describe '#create' do
    let(:new_site) { Locomotive::Entities::Site.new({ name: 'Acme', domains: ['www.acme.net'] })}

    it 'tells the adapter to create the record' do
      expect(adapter).to receive(:create).with(:sites, new_site, :en)
      repository.create(new_site, :en)
    end
  end
end
