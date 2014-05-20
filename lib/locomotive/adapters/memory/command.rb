module Locomotive
  module Adapters
    module Memory

      class Command

        def initialize(dataset, collection)
          @dataset, @collection = dataset, collection
        end

        def create(entity, locale)
          @dataset.create(
            _serialize(entity, locale)
          )
        end

        def update(entity, locale)
          @dataset.update(
            _serialize(entity, locale)
          )
        end

        private

        def _serialize(entity, locale)
          @collection.serialize(entity, locale)
        end
      end
    end
  end
end
