# irb -r locomotive_models -I ./lib

require 'pry'

adapter = Locomotive::Adapters::MemoryAdapter
locale = :en

class Article
  include Locomotive::Entity
  attributes :title, :author
end

class Author
  include Locomotive::Entity
  attributes :name
end

class ArticlesRepository
  include Locomotive::Repository
end

class AuthorsRepository
  include Locomotive::Repository
end

mapper = Locomotive::Mapper.new(adapter) do
  collection :articles do
    entity Article
    repository ArticlesRepository

    attribute :title
    attribute :author, association: :authors
  end

  collection :authors do
    entity Author
    repository AuthorsRepository

    attribute :name
  end
end.load!

authors_repository  = Locomotive::Models.mapper.collection(:authors).repository
# authors_repository  = Locomotive[:authors]
articles_repository = Locomotive::Models.mapper.collection(:articles).repository

author  = Author.new(name: 'John')
authors_repository.create author, locale

article = Article.new(title: "Title #{rand(100_000)}", author: author)
articles_repository.create article, locale

my_article = articles_repository.find author.id, locale
my_article.author

