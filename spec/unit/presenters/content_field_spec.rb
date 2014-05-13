require 'spec_helper'

describe Locomotive::Presenters::ContentField do


  context '#to_hash' do
    let(:content_field) { Locomotive::Entities::ContentField.new(type: 'select', select_options: select_options) }
    let(:context) { Hash.new }
    subject { Locomotive::Presenters::ContentField.new(content_field, context).select_options_to_hash }
  
    context 'partially localized options' do

      let(:select_options) { build_options([{ en: 'IT' }, { en: 'Business', fr: 'Business (FR)' }]) }
      it { should == { 'en' => ['IT', 'Business'], 'fr' => [nil, 'Business (FR)'] } }
    end

    context 'fully localized options' do

      let(:select_options) { build_options([{ en: 'IT', fr: 'IT (FR)' }, { en: 'Business', fr: 'Business (FR)' }]) }
      it { should == { 'en' => ['IT', 'Business'], 'fr' => ['IT (FR)', 'Business (FR)'] } }
    end
  end

  def build_options(names)
    names.map do |name|
      Locomotive::Entities::ContentSelectOption.new(name: name)
    end
  end
end