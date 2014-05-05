require_relative 'memory/dataset'
require_relative 'memory/condition'
require_relative 'memory/query'
require_relative 'memory/empty_loader'
require_relative 'memory/yaml_loader'

module Locomotive
  module Adapters

    class MemoryAdapter

      def initialize(loader = nil)
        @loader   = loader || Memory::EmptyLoader.new
        @datasets = Hash.new { |hash, name| hash[name] = Memory::Dataset.new(@loader.get(name)) }
      end

      def all(collection)
        Locomotive::Mapping::Collection.new(collection).deserialize(dataset(collection).all)
      end

      def create(collection, entity)
        dataset(collection).all << entity.to_record
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

      private

      def dataset(collection)
        @datasets[collection]
      end

    end

  end
end
