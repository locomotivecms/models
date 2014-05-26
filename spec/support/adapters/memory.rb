RSpec.shared_context 'memory' do
  let(:datastore) do
    Locomotive::Datastore.new
  end

  let(:article_mapper) do
    Locomotive::Mapper.new do
      collection :article do
        entity Locomotive::Entities::Article
        attribute :title, localized: true
        attribute :content
      end
    end
  end

  let(:adapter) do
    Locomotive::Adapters::MemoryAdapter.new article_mapper
  end

  let(:article_repository) do
    Locomotive::ArticleRepository.new(datastore, adapter)
  end

  let(:records) do
    [{ title: 'new article', content: 'nothing has changed' }]
  end

  def fill_articles!
    records.each do |record|
      article_repository.create(Locomotive::Entities::Article.new(record), :en)
    end
  end
end
