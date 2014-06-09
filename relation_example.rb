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
  attributes :title, :published
end

class ArticlesRepository
  include Locomotive::Repository
end

class CommentsRepository
  include Locomotive::Repository

  def published
    query do
      where 'published.eq' => true
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
  end
end

articles_repository = Locomotive::Models[:articles]
comments_repository = Locomotive::Models[:comments]

unpublished_comment = Comment.new(title: 'New Comment', published: false)
published_comment   = Comment.new(title: 'New Comment', published: true)

article = Article.new(title: { en: "Title #{rand(100_000)}" }, comments: [unpublished_comment, published_comment])

articles_repository.create article

my_article = articles_repository.find article.id
my_article.comments

comments_repository.published
