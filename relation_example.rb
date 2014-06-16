# irb -r locomotive/models -I ./lib

require 'pry'
require_relative 'lib/locomotive/adapters/memory_adapter'

adapter = Locomotive::Adapters::MemoryAdapter

class Article
  include Locomotive::Entity
  attributes :title, :author, :comments
end

class Comment
  include Locomotive::Entity
  attributes :title, :published, :article_id
end

class ArticlesRepository
  include Locomotive::Repository

  def with_published_comments id
    article = find(id)
    load_association! article, :comments, Locomotive::Models[:comments].published_for_article_id(id)
    article
  end
end

class CommentsRepository
  include Locomotive::Repository

  def published_for_article_id id
    article(id).tap do |wrapper|
      wrapper.query + published.query
    end
  end

  def published
    query do
      where 'published.eq' => true
    end
  end

  def article id
    query do
      where 'article_id.eq' => id
    end
  end
end

mapper = Locomotive::Mapper.new(adapter) do
  collection :articles do
    entity Article
    repository ArticlesRepository

    attribute :title, localized: true
    attribute :comments, association: :comments
  end

  collection :comments do
    entity Comment
    repository CommentsRepository

    attribute :title
    attribute :published
    attribute :article_id
  end
end

articles_repository = Locomotive::Models[:articles]
comments_repository = Locomotive::Models[:comments]

unpublished_comment = Comment.new(title: 'New Comment', published: false)
published_comment   = Comment.new(title: 'New Comment', published: true)
another_comment     = Comment.new(title: 'New Comment', published: true)

comments_repository.create unpublished_comment
comments_repository.create published_comment
comments_repository.create another_comment

article = Article.new(title: { en: "Title #{rand(100_000)}" }, comments: [])
articles_repository.create article

article.comments << unpublished_comment
article.comments << published_comment

articles_repository.update article

my_article = articles_repository.find article.id
my_article.comments.all

my_article = articles_repository.with_published_comments article.id
my_article.comments.all

Locomotive::Models[:comments].all.size

# comments_repository.article article.id

# articles_repository.load_association! my_article, :comments, comments_repository.published
#
# my_article = articles_repository.with_published_comments article.id
# my_article.comments
