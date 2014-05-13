require 'spec_helper'

describe Locomotive::Entities::Page do

  it 'builds an empty page' do
    build_page.should_not be_nil
  end

  def build_page(attributes = {})
    Locomotive::Entities::Page.new(attributes)
  end

end
