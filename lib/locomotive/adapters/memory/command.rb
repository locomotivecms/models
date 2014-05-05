module Locomotive
  module Adapters
    module Memory

      class Command

        def initialize(dataset, collection)
          @dataset, @collection = dataset, collection
        end

        def create(entity)
          @dataset.create(
            _serialize(entity)
          )
        end

        private

        def _serialize(entity)
          Locomotive::Mapping::Collection.new(@collection).serialize(entity)
        end
      end
    end
  end
end
