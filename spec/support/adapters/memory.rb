RSpec.shared_context 'memory' do
  let(:datastore) do
    Locomotive::Datastore.new
  end

  let(:article_mapper) do
    mapper = Locomotive::Mapper.new do
      collection :articles do
        entity Locomotive::Entities::Article
        attribute :title,   klass: String, localized: true
        attribute :content, klass: String
      end
    end
    mapper.load!
    mapper
  end

  let(:adapter) do
    Locomotive::Adapters::MemoryAdapter.new article_mapper
  end

  let(:articles_repository) do
    Locomotive::ArticlesRepository.new(datastore, adapter)
  end

  let(:records) do
    [{ title: 'new article', content: 'nothing has changed' }]
  end

  def fill_articles!

    records.each do |record|
      articles_repository.create(Locomotive::Entities::Article.new(record), :en)
    end
  end
end
