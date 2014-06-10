require 'spec_helper'

describe 'query' do
  include_context 'memory'

  context 'with record' do

    let(:entity)  { Example::Article.new(record) }
    let(:records) do
      [ { title: { en: 'Screen 1', fr: 'Ecran 1' }, content: 'content 1' },
        { title: { en: 'Screen 2', fr: 'Ecran 2' }, content: 'content 2' } ]
    end

    before do fill_articles! end

    specify do
      expect(articles_repository.all.size).to eq(2)
    end

    context 'en' do
      let(:locale)  { :en }

      specify('can be chained') do
        expect(
          title = articles_repository.query(locale) do
            where('content.eq' => 'content 1').
            where('id.lt' => 2)
          end.first.title.to_s
        ).to eq('Screen 1')
      end

      specify('i18n field') do
        expect(
          articles_repository.query(locale) do
            where('title.eq' => 'Screen 2')
            where('id.gt' => 1)
          end.first.title.to_s
        ).to eq('Screen 2')
      end

    end

    context 'fr' do
      let(:locale)  { :fr }

      specify('can be chained') do
        expect(
          articles_repository.query(locale) do
            where('content.eq' => 'content 1').
            where('id.lt' => 2)
          end.first.title.fr
        ).to eq('Ecran 1')
      end

      specify('i18n field') do
        expect(
          articles_repository.query(locale) do
            where('title.eq' => 'Ecran 2')
            where('content.matches' => /content/)
            where('id.gt' => 1)
          end.first.title.fr
        ).to eq('Ecran 2')
      end

    end
  end
end
