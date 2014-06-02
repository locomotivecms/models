require 'spec_helper'
require 'fixtures/example_entities'

module Locomotive
  describe 'Handling relationships' do

    include_context 'memory'

    let(:article) do
      Example::Article.new(title: 'My title', content: 'The article content',
        author: author, comments: [comment]) }
    let(:author)  { Example::Author.new(name: 'John') }
    let(:comment) { Example::Comment.new(title: 'awesome', content: 'Lorem ipsum dolor sit amet, ...', ) }

    let(:locale)  { :en }

    describe 'n-1 relationship' do

      describe 'Saving and retreiving' do
        before do
          comments_repository.create comment, locale
          authors_repository.create author, locale
          articles_repository.create article, locale
        end

        it 'allows to retreive associated record id' do
          article_double = articles_repository.find(article.id, :en)
          article_double.author.id.should eql author.id
        end

        it 'Lazily loads the associated record' do
          article_double = articles_repository.find(article.id, :en)
          article_double.author.name.should eq 'John'
          article_double.author.should be_kind_of Example::Author
        end

      end
    end
  end
end
