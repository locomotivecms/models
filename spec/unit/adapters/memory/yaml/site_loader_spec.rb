require 'spec_helper'

describe Locomotive::Adapters::Memory::Yaml::SiteLoader do

  let(:path) { File.expand_path('../../../../../fixtures/default', __FILE__) }

  subject { Locomotive::Adapters::Memory::Yaml::SiteLoader.new(path).to_a }

  describe 'from an unknown path' do

    let(:path) { '' }

    it 'raises an exception' do
      lambda { subject }.should raise_exception
    end

  end

  it 'gets all the attributes of the site' do
    subject.first.should == {
      'name' => 'Sample website',
      'subdomain' => 'sample',
      'domains' => ['sample.example.com', '0.0.0.0'],
      'locales' => ['en', 'fr', 'nb'],
      'seo_title' => {
        'en' => 'A simple LocomotiveCMS website',
        'fr' => 'Un simple LocomotiveCMS site web'
      },
      'meta_keywords' => {
        'en' => 'some meta keywords',
        'fr' => 'quelques mots cles'
      },
      'meta_description' => 'some meta description'
    }
  end

end