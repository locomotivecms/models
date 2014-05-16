require 'spec_helper'

describe Locomotive::Entities::Site do

  it 'builds an empty site' do
    build_site.should_not be_nil
  end

  describe '#to_s' do
    it 'returns the site name' do
      build_site(name: 'My Site').to_s.should eq 'My Site'
    end
  end

  def build_site(attributes = {})
    Locomotive::Entities::Site.new(attributes)
  end

end
