module Locomotive

  module Repository

    class RecordNotFound < StandardError; end

    attr_reader :mapper

    def initialize(mapper)
      @adapter = mapper.adapter
    end

    def all
      @adapter.all(collection)
    end

    def find(id)
      @adapter.find(collection, id)
    end

    def query(locale=nil, &block)
      @adapter.query(collection, locale, &block)
    end

    # def where(constraints, values)
    #   @adapter.query do
    #     where(constraints => values)
    #   end
    # end

    def create(entity)
      entity.id = @adapter.create(collection, entity)
    end

    def persisted?(entity)
      !!entity.id && @adapter.persisted?(collection, entity)
    end

    def update(entity)
      @adapter.update(collection, entity)
    end

    def destroy(entity)
      @adapter.destroy(collection, entity)
    end

    def collection
      self.class.name.split("::").last.sub(/Repository\Z/, '').scan(/[A-Z][a-z]*/).join("_").downcase.to_sym
    end
  end
end
