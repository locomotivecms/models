collection :products do
  entity Locomotive::Example::Product
  repository Locomotive::Example::ProductsRepository

  attribute :title, localized: true
  attribute :price
end

collection :articles do
  entity Locomotive::Example::Article
  repository Locomotive::Example::ArticlesRepository

  attribute :title, localized: true
  attribute :content,  klass: String

  attribute :author_id # Make reflection around keep this field or store id on author direclty
  attribute :author,   association: { type: :belongs_to, key: :author_id, name: :authors }

  attribute :comments, association: { type: :has_many, key: :article_id, name: :comments }
end

collection :authors do
  entity Locomotive::Example::Author
  repository Locomotive::Example::AuthorsRepository

  attribute :name

  attribute :articles, association: { type: :has_many, key: :author_id, name: :articles }
end

collection :comments do
  entity Locomotive::Example::Comment
  repository Locomotive::Example::CommentsRepository

  attribute :title
  attribute :content

  attribute :article_id
  attribute :article, association: { type: :belongs_to, key: :article_id, name: :articles }
end
