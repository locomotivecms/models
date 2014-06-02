collection :products do
  entity Locomotive::Example::Product
  repository Locomotive::Example::ProductsRepository

  attribute :title, localized: true
  attribute :price
end

collection :articles do
  entity Locomotive::Example::Article
  repository Locomotive::Example::ArticlesRepository

  attribute :title,    klass: String, localized: true
  attribute :content,  klass: String

  attribute :author,   association: :authors
  attribute :comments, association: :comments
end

collection :authors do
  entity Locomotive::Example::Author
  repository Locomotive::Example::AuthorsRepository

  attribute :name
end

collection :comments do
  entity Locomotive::Example::Comment
  repository Locomotive::Example::CommentsRepository

  attribute :title
  attribute :content
  attribute :article, association: :articles
  attribute :author,  association: :authors
end
