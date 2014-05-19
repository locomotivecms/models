module Locomotive

  module Repository

    def initialize(datastore, adapter, _locale)
      @datastore  = datastore
      @adapter    = adapter
      self.locale = _locale
    end

    def locale
      @locale
    end

    def locale= locale
      @locale = locale
    end

    def all(locale)
      @adapter.all(collection, locale)
    end

    def find(slug)
      @adapter.find(collection, slug)
    end

    def query(&block)
      @adapter.query(collection, &block)
    end

    def create entity, locale
      @adapter.create(collection, entity, locale)
    end

    def collection
      # TODO: mapper will go here
      self.class.name.split("::").last.sub(/Repository$/, '').scan(/[A-Z][a-z]*/).join("_").downcase.to_sym
    end
  end
end
