module Locomotive

  module Repository

    class RecordNotFound < StandardError; end

    def initialize(datastore, adapter)
      @datastore  = datastore
      @adapter    = adapter
    end

    def all(locale)
      @adapter.all(collection, locale)
    end

    def find(id, locale)
      @adapter.find(collection, id, locale)
    end

    def query(&block)
      @adapter.query(collection, &block)
    end

    def create(entity, locale)
      entity.id = @adapter.create(collection, entity, locale)
    end

    def persisted?(entity)
      !!entity.id && @adapter.persisted?(collection, entity)
    end

    def update(entity, locale)
      @adapter.update(collection, entity, locale)
    end

    def destroy(entity)
      @adapter.destroy(collection, entity)
    end

    def collection
      self.class.name.split("::").last.sub(/Repository\Z/, '').scan(/[A-Z][a-z]*/).join("_").downcase.to_sym
    end
  end
end
