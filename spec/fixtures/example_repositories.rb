  module Locomotive
  module Example
    class ArticlesRepository
      include Locomotive::Repository
    end

    class AuthorsRepository
      include Locomotive::Repository
    end

    class ProductsRepository
      include Locomotive::Repository
    end

    class CommentsRepository
      include Locomotive::Repository
    end
  end
end
