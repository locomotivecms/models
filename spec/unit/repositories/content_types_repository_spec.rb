require 'spec_helper'
require 'ostruct'

describe Locomotive::Repositories::ContentTypesRepository do

  describe '#collection' do
    subject { Locomotive::Repositories::ContentTypesRepository.new(nil, nil).collection }
    it { should eql :content_types }
  end

end