# irb -r locomotive/models -I ./lib

require 'pry'
require_relative 'lib/locomotive/adapters/memory_adapter'

adapter = Locomotive::Adapters::MemoryAdapter
locale = :en

class Article
  include Locomotive::Entity
  attributes :title, :author, :comments
end

class Author
  include Locomotive::Entity
  attributes :name
end

class Comment
  include Locomotive::Entity
  attributes :title
end

class ArticlesRepository
  include Locomotive::Repository
end

class AuthorsRepository
  include Locomotive::Repository
end

class CommentsRepository
  include Locomotive::Repository
end

mapper = Locomotive::Mapper.new(adapter) do
  collection :articles do
    entity Article
    repository ArticlesRepository

    attribute :title, localized: true
    attribute :author, association: :authors
    attribute :comments, association: :comments
  end

  collection :authors do
    entity Author
    repository AuthorsRepository

    attribute :name
  end

  collection :comments do
    entity Comment
    repository CommentsRepository

    attribute :title
  end

end

articles_repository = Locomotive::Models[:articles]
comments_repository = Locomotive::Models[:comments]

author  = Author.new(name: 'John')
authors_repository.create author

comment = Comment.new(title: 'New Comment')
comments_repository.create comment

article = Article.new(title: {en:"Title #{rand(100_000)}"}, author: author, comments: [comment])
articles_repository.create article

my_article = articles_repository.find my_article.id
my_article.author
my_article.comments
