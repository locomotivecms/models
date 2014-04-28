module Locomotive
  module Adapters
    module Memory

      class Dataset

        include Enumerable
        extend  Forwardable

        def_delegators :all, :each, :to_s, :empty?, :size
        def_delegators :query, :where, :order_by

        def initialize(loader)
          @loader = loader
        end

        def each(&block)
          dataset.each(&block)
        end

        def all
          dataset
        end

        def query
          Query.new(self)
        end

        private

        def dataset
          @dataset ||= @loader.to_a
        end

      end

    end
  end
end