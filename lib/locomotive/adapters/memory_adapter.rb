require_relative 'memory/dataset'
require_relative 'memory/condition'
require_relative 'memory/query'
require_relative 'memory/command'
require_relative 'memory/empty_loader'
require_relative 'memory/yaml_loader'

module Locomotive
  module Adapters

    class MemoryAdapter

      def initialize mapper
        @mapper = mapper
        @datasets = Hash.new { |hash, name| hash[name] = Memory::Dataset.new(name) }
      end

      def all(collection, locale)
        _mapped_collection(collection, locale).deserialize(dataset(collection).all)
      end

      def create(collection, entity, locale)
        Memory::Command.new(dataset(collection), _mapped_collection(collection, locale)).create(entity)
      end

      def update(collection, entity, locale)
        Memory::Command.new(dataset(collection), _mapped_collection(collection, locale)).update(entity)
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

      def query(collection, &block)
        Memory::Query.new(dataset(collection), &block)
      end

        # TODO move to query
      def find(collection, id, locale)
        
        record = dataset(collection).find(id)
        
        _mapped_collection(collection, locale).deserialize([record]).first
      end

      private

      def dataset(collection)
        @datasets[collection]
      end

      def _mapped_collection(name, locale)
        @mapper.collection(name, locale)
      end

    end

  end
end
