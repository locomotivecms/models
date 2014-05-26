module ExampleEntities
  class Article
    include Locomotive::Entity
    attributes :title, :content, :author
  end

  class Author
    include Locomotive::Entity
    attributes :name
  end

  class Product
    include Locomotive::Entity
    attributes :title, :price
  end
end
