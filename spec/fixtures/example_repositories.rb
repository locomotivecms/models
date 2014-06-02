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

      def where(locale, constraints, values)
        query(locale) do
          where(constraints => values)
        end
      end

    end
  end
end
