collection :product do

  entity ExampleEntities::Product

  attribute :title, localized: true
  attribute :price
end

collection :article do

  entity ExampleEntities::Article

  attribute :title,   localized: true
  attribute :content, localized: true
  attribute :author,  association: true
end

collection :author do

  entity ExampleEntities::Author

  attribute :name

end
