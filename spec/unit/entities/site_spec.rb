require 'spec_helper'

describe Locomotive::Entities::Site do

  it 'builds an empty site' do
    build_site.should_not be_nil
  end

  describe 'building a site from attributes' do

    it 'raises an exception if the field does not exist' do
      expect {
        build_site(template: 'Hello world')
      }.to raise_error
    end

    it 'sets a simple attribute' do
      build_site(name: 'Hello world').name.should == 'Hello world'
    end

    it 'sets a more complex attribute' do
      build_site(locales: %w(en fr)).locales.should == %w(en fr)
    end

    it 'sets a localized attribute' do
      site = build_site(seo_title: { en: 'Hello world' })
      site.seo_title.should eq({ en: 'Hello world' })
    end

    it 'sets a complete translation of a localized attribute' do
      site = build_site(seo_title: { en: 'Hello world', fr: 'Salut le monde' })
      site.seo_title.should == { en: 'Hello world', fr: 'Salut le monde' }
    end
  end

  describe 'setting attributes' do
    let(:site) { build_site }

    it 'sets a simple attribute' do
      site.name = 'Hello world'
      site.name.should == 'Hello world'
    end

    it 'reject scalar for localized attribute' do
      expect { site.seo_title = 'Hello world' }.to raise_error(Locomotive::AbstractField::UnsupportedFormat)
    end
  end

  describe 'retrieving attributes' do
    let(:site) do
      build_site(name: 'Hello world', seo_title: { en: 'A title' },
        meta_description: { en: 'Hello world', fr: 'Salut le monde' })
    end

    it 'returns all of them' do
      site.attributes.should eq({ name: 'Hello world', locales: nil, seo_title: { en: 'A title' },
        meta_keywords: nil, meta_description: { en: 'Hello world', fr: 'Salut le monde' },
        subdomain: nil, domains: nil, robots_txt: nil, timezone: nil })
    end
  end

  def build_site(attributes = {})
    Locomotive::Entities::Site.new(attributes)
  end

end
