require 'spec_helper'

describe Locomotive::Entities::Snippet do

  it 'builds an empty snippet' do
    build_snippet.should_not be_nil
  end

  def build_snippet(attributes = {})
    Locomotive::Entities::Snippet.new(attributes)
  end

end
