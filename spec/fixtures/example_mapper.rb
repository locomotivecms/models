collection :article do
  entity ExampleEntities::Article

  attribute :title, localized: true
  attribute :content, localized: true
end

collection :author do
  entity ExampleEntities::Author

  attribute :name
end
