require 'spec_helper'

describe Locomotive::Entities::ThemeAsset do

  it 'builds an empty theme asset' do
    build_theme_asset.should_not be_nil
  end

  def build_theme_asset(attributes = {})
    Locomotive::Entities::ThemeAsset.new(attributes)
  end

end
