# irb -r locomotive/models -I ./lib

require 'pry'

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

  def where(locale, constraints, values)
    query(locale) do
      where(constraints => values)
    end
  end
end

mapper = Locomotive::Mapper.new(adapter) do
  collection :articles do
    entity Article
    repository ArticlesRepository

    attribute :title
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

authors_repository  = Locomotive::Models[:authors]
articles_repository = Locomotive::Models[:articles]
comments_repository = Locomotive::Models[:comments]

author  = Author.new(name: 'John')
authors_repository.create author, locale

comment = Comment.new(title: 'New Comment')
comments_repository.create comment, locale

article = Article.new(title: "Title #{rand(100_000)}", author: author, comments: [comment])
articles_repository.create article, locale

my_article = articles_repository.find author.id, locale
my_article.author
my_article.comments
