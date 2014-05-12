require 'spec_helper'

describe Locomotive::Entities::Snippet do

  it 'builds an empty snippet' do
    build_snippet.should_not be_nil
  end

  describe 'building a snippet from attributes' do

    it 'raises an exception of the field does not exist' do
      expect {
        build_snippet(template_filepath: 'Hello world')
      }.to raise_error Locomotive::Fields::FieldDoesNotExistException
    end

    it 'sets a simple attribute' do
      build_snippet(name: 'Header').name.should == 'Header'
    end

    it 'sets a localized attribute' do
      snippet = build_snippet(template: { en: 'header.liquid.haml' })
      snippet.template.should eq en: 'header.liquid.haml'
    end

    it 'sets a complete translation of a localized attribute' do
      snippet = build_snippet(template: { en: 'header.liquid.haml', fr: 'header.fr.liquid.haml' })
      snippet.template.should eq en: 'header.liquid.haml', fr: 'header.fr.liquid.haml'
    end

  end

  describe 'setting attributes' do

    before(:each) do
      @snippet = build_snippet
    end

    it 'sets a simple attribute' do
      @snippet.name = 'Header'
      @snippet.name.should == 'Header'
    end

    it 'sets a localized attribute' do
      @snippet.template = { en: 'header.liquid.haml' }
      @snippet.template.should eq en: 'header.liquid.haml'
    end

  end

  describe '#source' do
    subject { build_snippet attributes }

    let(:attributes) {{ template: { en: template_path } }}
    let(:template_path) { 'a/en/path' }

    context 'when template is a path' do
      it 'returns a string' do
        subject.source(:en).should eq 'a/en/path'
      end
    end

    context 'when template is a "template"' do
      let(:template_path) { double(source: 'template rendered') }
      it 'returns the rendered template' do
        subject.source(:en).should eq 'template rendered'
      end
      context '#to_params' do
        let(:attributes) {{ name: 'foo', slug: '123', template: { en: template_path } }}
        it 'returns ' do
          subject.to_params(:en).should eq name: 'foo', slug: '123', template: 'template rendered'
        end
      end
    end

    context 'when locale is not set' do
      it 'returns nil' do
        subject.source(:wk).should be_nil
      end
    end
  end


  def build_snippet(attributes = {})
    Locomotive::Entities::Snippet.new(attributes)
  end

end
