require 'spec_helper'

describe Locomotive::Entities::Translation do

  it 'builds an empty translation' do
    build_translation.should be_kind_of Locomotive::Entities::Translation
  end

  def build_translation(attributes = {})
    Locomotive::Entities::Translation.new(attributes)
  end

end