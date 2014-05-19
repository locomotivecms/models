module Locomotive
  module Adapters
    module Memory

      class Dataset

        class PrimaryKey
          def initialize
            @current = 0
          end

          def increment!
            yield(@current += 1)
            @current
          end
        end

        attr_reader :records, :name

        def initialize(name)
          @name, @records = name, {}
          @primary_key = PrimaryKey.new
        end

        def create(entity)
          @primary_key.increment! do |id|
            entity[identity] = id
            records[id] = entity
          end
        end

        def update(entity)
          records[entity.id] = records[entity.id].deep_merge(entity)
        end

        def all
          records.values
        end

        def query
          Query.new(self)
        end

        private

        def identity
          @identity ||= :id
        end

      end
    end
  end
end
