# irb -r locomotive/models -I ./lib

require 'pry'
require_relative 'lib/locomotive/adapters/memory_adapter'

adapter = Locomotive::Adapters::MemoryAdapter

class Article
  include Locomotive::Entity
  attributes :title
end

class ArticlesRepository
  include Locomotive::Repository
end

mapper = Locomotive::Mapper.new(adapter) do
  collection :articles do
    entity Article
    repository ArticlesRepository

    attribute :title, localized: true
  end
end

articles_repository = Locomotive::Models[:articles]

title = Locomotive::Fields::I18nField.new({ en: "Title #{rand(100_000)}" })

article = Article.new(title: title)
articles_repository.create article

my_article = articles_repository.find article.id
my_article.title

my_article.title << { fr: "Titre #{rand(100_000)}" }
articles_repository.update my_article

my_1_article = articles_repository.find my_article.id
my_1_article.title

my_1_article.title.en
# => "Title 97960"
my_1_article.title.fr
# => "Titre 35579"
