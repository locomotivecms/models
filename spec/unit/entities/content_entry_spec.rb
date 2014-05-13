require 'spec_helper'

describe Locomotive::Entities::ContentEntry do

  let(:content_entry) { build_content_entry }
  let(:content_type) { Locomotive::Entities::ContentType.new }

  describe 'setting default attributes' do

    it 'builds an empty content entry'  do
      content_entry.should be_kind_of Locomotive::Entities::ContentEntry
    end
  end

  def build_content_entry(attributes = {})
    Locomotive::Entities::ContentEntry.new(attributes.merge(content_type: content_type))
  end

end
