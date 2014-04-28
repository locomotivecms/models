module Locomotive
  module Adapters
    module Memory

      class Query

        include Enumerable
        extend  Forwardable

        def_delegators :all, :each, :to_s, :empty?

        def initialize(dataset, &block)
          @dataset    = dataset
          @conditions = []
          instance_eval(&block) if block_given?
        end

        def where(conditions = {})
          @conditions += conditions.map { |name, value| Condition.new(name, value) }
          self
        end

        def all
          result = @dataset.all.dup

          result.find_all do |entry|
            accepted = true

            @conditions.each do |_condition|
              unless _condition.matches?(entry)
                accepted = false
                break # no to go further
              end
            end

            accepted
          end
        end

      end

    end
  end
end