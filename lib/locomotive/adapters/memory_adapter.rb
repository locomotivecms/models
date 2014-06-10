require_relative 'memory/dataset'
require_relative 'memory/condition'
require_relative 'memory/query'
require_relative 'memory/command'
require_relative 'memory/wrapper'

module Locomotive
  module Adapters

    class MemoryAdapter

      def initialize mapper
        @mapper = mapper
        @datasets = Hash.new { |hash, name| hash[name] = Memory::Dataset.new(name) }
      end

      def all(collection)
        _mapped_collection(collection).deserialize(dataset(collection).all)
      end

      def create(collection, entity)
        Memory::Command.new(dataset(collection), _mapped_collection(collection)).create(entity)
      end

      def update(collection, entity)
        Memory::Command.new(dataset(collection), _mapped_collection(collection)).update(entity)
      end

      def destroy(collection, entity)
        Memory::Command.new(dataset(collection), collection).destroy(entity)
      end

      def persisted?(collection, entity)
        entity.id && dataset(collection).exists?(entity.id)
      end

      def first(collection)
        dataset(collection).first
      end

      def last(collection)
        dataset(collection).last
      end

      def size(collection)
        dataset(collection).size
      end

      def query(collection, locale=nil, &block)
        query = Memory::Query.new(dataset(collection), locale, &block)
        Memory::Wrapper.new query, _mapped_collection(collection)
      end

      def find(collection, id)
        record = dataset(collection).find(id)
        _mapped_collection(collection).deserialize([record]).first
      end


      private

      def dataset(collection)
        @datasets[collection]
      end

      def _mapped_collection(name)
        @mapper.collection(name)
      end

    end
  end
end
