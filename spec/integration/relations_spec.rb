require 'spec_helper'
require 'fixtures/example_entities'

module Locomotive
  describe 'Handling relationships', focused: true do

    let(:datastore) do
      Datastore.new(mapper: mapper, adapter: adapter)
    end

    let(:adapter) do
      Adapters::MemoryAdapter.new(mapper)
    end

    let(:article_repository) do
      class ArticleRepository
        include Repository
      end.new(datastore, adapter)
    end

    let(:author_repository) do
      class AuthorRepository
        include Repository
      end.new(datastore, adapter)
    end

    let(:mapper) do
      Mapper.load! File.expand_path('../../fixtures/example_mapper.rb', __FILE__)
    end

    let(:article) { ExampleEntities::Article.new(title: 'My title', content: 'The article content', author: author) }
    let(:author)  { ExampleEntities::Author.new(name: 'John') }
    let(:locale)  { :en }

    describe 'n-1 relationship' do
      describe 'Saving and retreiving' do
        before do
          author_repository.create author, locale
          article_repository.create article, locale
        end

        it 'allows to retreive associated record id' do
          article_double = article_repository.find(article.id, :en)
          article_double.author.id.should eql author.id
        end
      end
    end
  end
end
