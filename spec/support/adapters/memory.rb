require 'fixtures/example_entities'
require 'fixtures/example_repositories'

RSpec.shared_context 'memory' do
  let(:datastore) do
    Locomotive::Datastore.new
  end

  let(:mapper_file) do
    File.expand_path('../../../fixtures/example_mapper.rb', __FILE__)
  end
  
  let(:article_mapper) do
    mapper = Locomotive::Mapper.load_from_file! mapper_file
    mapper.load!
    mapper
  end

  let(:adapter) do
    Locomotive::Adapters::MemoryAdapter.new article_mapper
  end

  let(:articles_repository) do
    Locomotive::Example::ArticlesRepository.new(datastore, adapter)
  end

  let(:authors_repository) do
    Locomotive::Example::AuthorsRepository.new(datastore, adapter)
  end

  let(:records) do
    [{ title: 'new article', content: 'nothing has changed' }]
  end

  def fill_articles!
    records.each do |record|
      articles_repository.create(Locomotive::Example::Article.new(record), :en)
    end
  end
end
