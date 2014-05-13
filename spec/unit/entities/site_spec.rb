require 'spec_helper'

describe Locomotive::Entities::Site do

  it 'builds an empty site' do
    build_site.should_not be_nil
  end

  def build_site(attributes = {})
    Locomotive::Entities::Site.new(attributes)
  end

end
