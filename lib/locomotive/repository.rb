module Locomotive

  module Repository

    def initialize(datastore, adapter)
      @datastore  = datastore
      @adapter    = adapter
    end

    def all
      @adapter.all(collection)
    end

    def find(slug)
      @adapter.find(collection, slug)
    end

    def query(&block)
      @adapter.query(collection, &block)
    end

    def create entity
      @adapter.create(collection, entity)
    end

    def collection
      # TODO: mapper will go here
      self.class.name.split("::").last.sub(/Repository$/, '').scan(/[A-Z][a-z]*/).join("_").downcase.to_sym
    end

  end

end
