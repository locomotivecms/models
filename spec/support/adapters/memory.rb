module Locomotive
  module Entities
    class Article
      include Entity

      attributes :title
      attributes :content
    end
  end
end

@mapper = Locomotive::Mapper.new do
  collection :article do
    entity Locomotive::Entities::Article
    attribute :title, localized: true
    attribute :content
  end
end

@datastore = Locomotive::Datastore.new
@adapter   = Locomotive::Adapters::MemoryAdapter.new @mapper

class Locomotive::ArticleRepository
  include Locomotive::Repository
end

@repository = Locomotive::ArticleRepository.new(@datastore, @adapter)
