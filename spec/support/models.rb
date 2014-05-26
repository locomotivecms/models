module Locomotive
  module Entities
    class Article
      include Entity

      attributes :title
      attributes :content
    end
  end
end

class Locomotive::ArticleRepository
  include Locomotive::Repository
end
