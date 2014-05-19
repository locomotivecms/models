require 'spec_helper'

describe Locomotive::Entities::ContentType do

  it 'builds an empty content type' do
    build_content_type.should_not be_nil
  end

  def build_content_type(attributes = {})
    Locomotive::Entities::ContentType.new(attributes)
  end

end
