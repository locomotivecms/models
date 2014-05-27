collection :products do
  entity Locomotive::Example::Product

  attribute :title, localized: true
  attribute :price
end

collection :articles do
  entity Locomotive::Example::Article

  attribute :title,   klass: String, localized: true
  attribute :content, klass: String
  attribute :author,  association: true
  attribute :comments,  association: true
end

collection :authors do
  entity Locomotive::Example::Author

  attribute :name
end

collection :comments do
  entity Locomotive::Example::Comment

  attribute :title
  attribute :content
  attribute :article
end
