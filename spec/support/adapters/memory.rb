require 'fixtures/example_entities'
require 'fixtures/example_repositories'

RSpec.shared_context 'memory' do

  let(:mapper_file) do
    File.expand_path('../../../fixtures/example_mapper.rb', __FILE__)
  end

  let(:adapter) do
    Locomotive::Adapters::MemoryAdapter
  end

  let!(:mapper) do
    Locomotive::Mapper.load_from_file! adapter, mapper_file
  end

  let(:articles_repository) do
    Locomotive::Example::ArticlesRepository.new(mapper)
  end

  let(:authors_repository) do
    Locomotive::Example::AuthorsRepository.new(mapper)
  end

  let(:comments_repository) do
    Locomotive::Example::CommentsRepository.new(mapper)
  end

  let(:records) do
    [{ title: { en: 'new article' }, content: 'nothing has changed' }]
  end

  def fill_articles!
    records.each do |record|
      articles_repository.create(Locomotive::Example::Article.new(record))
    end
  end
end
