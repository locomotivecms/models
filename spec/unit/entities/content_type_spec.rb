require 'spec_helper'

describe Locomotive::Entities::ContentType do

  it 'builds an empty content type' do
    build_content_type.should_not be_nil
  end

  describe 'building a content type from attributes' do

    it 'raises an exception if the field does not exist' do
      expect {
        build_content_type(foo: 'Hello world')
      }.to raise_error Locomotive::Fields::FieldDoesNotExistException
    end

  end
  let(:custom_fields) do
   [
      { label: 'Title', 'name' => 'title' },
      { label: 'Description', 'name' => :description, type: :text }
    ]
  end

  describe 'fields' do

    it 'has 2 fields' do
      build_content_type(fields: custom_fields).fields.size.should == 2
    end

    it 'has the right class for each field' do
      build_content_type(fields: custom_fields).fields.each do |field|
        field.class.should eq Locomotive::Entities::ContentField
      end
    end

    it 'sets the right types' do
      build_content_type(fields: custom_fields).fields.first.type.should eq :string
      build_content_type(fields: custom_fields).fields.last.type.should eq :text
    end

  end

  describe '#label_to_slug' do

    let(:content_type) { build_content_type }

    it 'takes the parameterized version of the label when no entries' do
      content_type.send(:label_to_slug, 'hello-world').should == 'hello-world'
    end

    it 'generates an indexed but unique slug' do
      content_type.stub(entries: [mock_content_entry('hello-world')])
      content_type.send(:label_to_slug, 'hello-world').should == 'hello-world-1'
    end

    it 'increments correctly the index' do
      content_type.stub(entries: [mock_content_entry('hello-world'), mock_content_entry('hello-world-1')])
      content_type.send(:label_to_slug, 'hello-world').should == 'hello-world-2'
    end

  end

  describe '#find_field', pending: 'work on content_fields first' do
    subject { build_content_type(fields: custom_fields) }
    it 'returns the matching field' do
      subject.find_field(:description).label.should eq 'Description'  
    end
  end

  def build_content_type(attributes = {})
    Locomotive::Entities::ContentType.new(attributes)
  end

  def mock_content_entry(permalink)
    double.tap do |entry|
      entry.stub(_permalink: permalink)
      entry.stub(_label: permalink)
    end
  end

end
