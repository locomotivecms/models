require 'spec_helper'
require 'fixtures/example_entities'

module Locomotive
  describe 'Handling relationships' do

    include_context 'memory'

    let(:article) do
      Example::Article.new(title: { en:'My title' }, content: 'The article content', comments: [])
    end
    let(:author)  { Example::Author.new(name: 'John') }
    let(:comment) do
      Example::Comment.new(
        { title: 'awesome comment', content: 'Lorem ipsum dolor sit amet, ...' }
      )
    end

    # let(:locale)  { :en }

    describe 'n-1 relationship' do

      context 'set reference' do

        it 'save and retrive article reference' do
          articles_repository.create article
          article.id.should_not be_nil
          article.comments << comment
          articles_repository.update article

          comment.should respond_to :article_id
          comment.article_id.should eq article.id

          article_double = articles_repository.find(article.id)
          comment = article_double.comments.first

          comment.should respond_to :article_id
          comment.article_id.should eq article.id
        end
      end

      describe 'Saving and retreiving' do
        before do
          comments_repository.create comment
          authors_repository .create author
          articles_repository.create article
        end

        it 'allows to retreive associated record id', pending: true do
          article_double = articles_repository.find(article.id)
          article_double.author.id.should eql author.id
        end

        it 'Lazily loads the associated record', pending: true do
          article_double = articles_repository.find(article.id)
          article_double.author.name.should eq 'John'
          article_double.author.should be_kind_of Example::Author
          article_double.comments.first.should be_kind_of Example::Comment
          article_double.comments.first.title.should eq 'awesome comment'
        end
      end

      context 'when associated objects are non persisted', pending: true do

        # context 'set reference' do
        #   let(:article) do
        #     Example::Article.new(title: { en:'My title' }, content: 'The article content', comments: [comment])
        #   end
        #
        #   it '' do
        #     comment.should_not respond_to :article_id
        #     articles_repository.create article
        #     comment.should respond_to :article_id
        #     comment.article_id.should eq article.id
        #   end
        # end

        context 'one to many' do
          before do
            articles_repository.create article
            article.comments << comment
            articles_repository.update article
          end

          it 'Lazily loads the associated record' do
            article_double = articles_repository.find(article.id)

            comment = article_double.comments.first
            comment.should be_kind_of Example::Comment
            comment.id.should eq 1
            comment.title.should eq 'awesome'
            # comment.article_id.should eq article.id
          end
        end

        context 'belongs to' do
          before do
            articles_repository.create article
            article.author = author
            articles_repository.update article
          end

          it 'Lazily loads the associated record' do
            article_double = articles_repository.find(article.id)
            article_double.author.name.should eq 'John'
            article_double.author.should be_kind_of Example::Author
          end
        end

      end

    end
  end
end
