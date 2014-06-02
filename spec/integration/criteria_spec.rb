require 'spec_helper'

describe 'query' do
  include_context 'memory'

  context 'with record' do

    let(:entity)  { Example::Article.new(record) }
    let(:records) do
      [ { title: 'Article 1', content: 'content 1' },
        { title: 'Article 2', content: 'content 2' } ]
    end
    let(:locale)  { :en }

    before do fill_articles! end

    specify do
      expect(articles_repository.all(locale).size).to eq(2)
    end

    specify('can be chained') do
      expect(
        articles_repository.query(locale) do
          where('content.eq' => 'content 1').
          where('id.lt' => 2)
        end.first.title
      ).to eq('Article 1')
    end

  end

end
