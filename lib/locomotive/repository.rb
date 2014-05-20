module Locomotive

  module Repository

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

    def create entity, locale
      entity.id = @adapter.create(collection, entity, locale)
    end

    def update entity, locale
      @adapter.update(collection, entity, locale)
    end

    def collection
      self.class.name.split("::").last.sub(/Repository\Z/, '').scan(/[A-Z][a-z]*/).join("_").downcase.to_sym
    end
  end
end
