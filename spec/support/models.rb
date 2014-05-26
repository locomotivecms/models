module Locomotive
  module Entities
    class Article
      include Entity

      attributes :title
      attributes :content
    end
  end
end

class Locomotive::ArticlesRepository
  include Locomotive::Repository
end
