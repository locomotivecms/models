require 'spec_helper'

module Locomotive

  describe '' do
    include_context 'memory'

    let(:entity)  { Entities::Article.new(record) }
    let(:record)  {{ title: 'new article', content: 'nothing has changed' }}
    let(:records) {[ record ]}
    let(:locale)    { :en }

    describe '' do
      let(:records) do
        [ { title: 'new article', content: 'nothing has changed' },
          { title: 'new article', content: 'nothing has changed' }]
      end

      before do fill_articles! end

      specify do
        expect(article_repository.all(locale).size).to eq(2)
      end
    end

    describe 'write an entity' do
      before do
        article_repository.create(entity, locale)
      end
      specify do
        expect(article_repository.all(locale).size).to eq(1)
      end
      it 'gives an ID to the entity' do
        entity.id.should_not be_nil
      end
    end

    describe 'finding an entity by its ID' do
      context 'when entity exists' do
        before  { article_repository.create(entity, locale) }
        subject { article_repository.find(entity.id, locale) }

        it { should be_kind_of Entities::Article }
        its(:id) { should_not be_nil }
      end

      context 'when entity could not be found' do
        subject { article_repository.find(1234, :en) }
        it 'raises an error' do
          expect { subject }.to raise_error Repository::RecordNotFound, 'could not find article with id = 1234'
        end
      end
    end

    describe 'update an entity' do
      before do
        article_repository.create(entity, locale)
        entity.title= 'Jane Doe'
        article_repository.update(entity, locale)
      end

      it 'does not create a new record' do
        expect(article_repository.all(locale).size).to eq(1)
      end
    end

    describe 'destroying an entity' do
      before  { article_repository.create(entity, locale) }
      it 'destroys an entry' do
        article_repository.destroy(entity)
        expect(article_repository.all(locale).size).to eq(0)
      end
    end
  end
end
