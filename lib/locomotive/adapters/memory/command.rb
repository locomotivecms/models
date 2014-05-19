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

        def update(entity)
          @dataset.update(
            _serialize(entity)
          )
        end

        private

        def _serialize(entity)
          @collection.serialize(entity)
        end
      end
    end
  end
end
