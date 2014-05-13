require 'spec_helper'

describe Locomotive::Entities::ContentSelectOption do

  it 'builds an empty content select option' do
    build_option.should_not be_nil
  end

  def build_option(attributes = {})
    Locomotive::Entities::ContentSelectOption.new(attributes)
  end

end
