require 'spec_helper'

describe Locomotive::Entities::ContentField do

  it 'builds an empty content field' do
    build_content_field.should_not be_nil
  end

  describe 'building a content type from attributes' do

    it 'raises an exception if the field does not exist' do
      expect {
        build_content_field(foo: 'Hello world')
      }.to raise_error Locomotive::Fields::FieldDoesNotExistException
    end

    it 'has a default label based on the name' do
      build_content_field(name: 'a_field').label.should == 'A field'
    end

    it 'has a default type (string)' do
      build_content_field.type.should == :string
    end

    it 'has a default position' do
      build_content_field.position.should == 0
    end

    it 'has a default value for required (false)' do
      build_content_field.required.should be_false
    end

    it 'has a default value for localized (false)' do
      build_content_field.localized.should be_false
    end

    it 'has a type which always a symbol' do
      build_content_field(type: 'date').type.should == :date
    end

  end

  describe '.is_relationship?' do

    it 'is false for types other than belongs_to, has_many, many_to_many' do
      build_content_field(type: 'date').is_relationship?.should == false
    end

    %w(belongs_to has_many many_to_many).each do |type|
      it "is true for #{type}" do
        build_content_field(type: type).is_relationship?.should == true
      end
    end

  end

  describe 'select options' do

    subject {
      build_content_field(type: 'select', select_options: options)
    }

    context 'rejects non hash input' do

      let(:options) { build_options(['IT', 'Business']) }
      it do
        expect { subject }.to raise_error Locomotive::AbstractField::UnsupportedFormat
      end
    end

    context 'hash input' do

      let(:options) { build_options([{ en: 'IT' }, { en: 'Business', fr: 'Business (FR)' }]) }
      it { subject.select_options.size.should eq 2 }
      it { subject.select_options.first.should be_a Locomotive::Entities::ContentSelectOption }
      it { subject.select_options.first.name.should eq en: 'IT' }
    end
  end

  def build_content_field(attributes = {})
    Locomotive::Entities::ContentField.new(attributes)
  end

  def build_options(names)
    names.map do |name|
      Locomotive::Entities::ContentSelectOption.new(name: name)
    end
  end

end
