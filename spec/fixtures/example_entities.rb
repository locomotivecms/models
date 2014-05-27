module Locomotive
  module Example
    class Article
      include Locomotive::Entity
      attributes :title, :content, :author, :comments
    end

    class Author
      include Locomotive::Entity
      attributes :name
    end

    class Comment
      include Locomotive::Entity
      attributes :title, :content, :article
    end

    class Product
      include Locomotive::Entity
      attributes :title, :price
    end
  end
end
