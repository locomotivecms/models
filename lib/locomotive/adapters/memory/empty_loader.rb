module Locomotive
  module Adapters
    module Memory

      class EmptyLoader

        def get(name)
          @empty_loader ||= empty_loader_klass.new(:empty)
        end

        private

        def empty_loader_klass
          Struct.new(:name) do
            def to_a
              []
            end
          end
        end

      end

    end
  end
end