require_relative 'memory/dataset'
require_relative 'memory/condition'
require_relative 'memory/query'
require_relative 'memory/command'

module Locomotive
  module Adapters

    class MemoryAdapter

      def initialize mapper
        @mapper = mapper
        @datasets = Hash.new { |hash, name| hash[name] = Memory::Dataset.new(name) }
      end

      def all(collection, locale)
        _mapped_collection(collection).deserialize(dataset(collection).all, locale)
      end

      def create(collection, entity, locale)
        Memory::Command.new(dataset(collection), _mapped_collection(collection)).create(entity, locale)
      end

      def update(collection, entity, locale)
        Memory::Command.new(dataset(collection), _mapped_collection(collection)).update(entity, locale)
      end

      def destroy(collection, entity)
        Memory::Command.new(dataset(collection), collection).destroy(entity)
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

      def find(collection, id, locale)
        record = dataset(collection).find(id, locale)
        _mapped_collection(collection).deserialize([record], locale).first
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
