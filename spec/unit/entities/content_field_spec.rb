require 'spec_helper'

describe Locomotive::Entities::ContentField do

  it 'builds an empty content field' do
    build_content_field.should_not be_nil
  end

  def build_content_field(attributes = {})
    Locomotive::Entities::ContentField.new(attributes)
  end

end
