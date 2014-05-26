require 'spec_helper'
require 'fixtures/example_entities'

module Locomotive
  describe 'Handling relationships' do

    include_context 'memory'

    let(:mapper) do
      Mapper.load_from_file! File.expand_path('../../fixtures/example_mapper.rb', __FILE__)
    end

    let(:article) { Example::Article.new(title: 'My title', content: 'The article content', author: author) }
    let(:author)  { Example::Author.new(name: 'John') }
    let(:locale)  { :en }

    describe 'n-1 relationship' do
      describe 'Saving and retreiving' do
        before do
          authors_repository.create author, locale
          articles_repository.create article, locale
        end

        it 'allows to retreive associated record id' do
          article_double = articles_repository.find(article.id, :en)
          article_double.author.id.should eql author.id
        end

        it 'Lazily loads the associated record' do
          article_double = articles_repository.find(article.id, :en)
          authors_repository.load_association article_double, :author
          article_double.author.name.should eq 'John'
          article_double.author.should be_kind_of Example::Author
        end

      end
    end
  end
end
