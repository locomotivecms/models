module Locomotive
  module Adapters
    module Memory

      class Query

        include Enumerable
        extend  Forwardable

        def_delegators :all, :each, :to_s, :to_a, :empty?, :size
        alias :length :size
        alias :count :size

        def initialize(dataset, &block)
          @dataset    = dataset
          @conditions = []
          @sorting = nil
          instance_eval(&block) if block_given?
        end

        def where(conditions = {})
          @conditions += conditions.map { |name, value| Condition.new(name, value) }
          self
        end

        def order_by(order_string)
          @sorting = order_string.downcase.split.map(&:to_sym) unless order_string.empty?
          self
        end

        def ==(other)
          if other.kind_of? Array
            all == other
          else
            super
          end
        end

        def all
          sorted(filtered)
        end

        def sorted(entries)
          return entries if @sorting.nil?

          name, direction  = @sorting.first, (@sorting.last || :asc)
          if direction == :asc
            entries.sort { |a, b| a.send(name) <=> b.send(name) }
          else
            entries.sort { |a, b| b.send(name) <=> a.send(name) }
          end
        end

        def filtered
          @dataset.all.dup.find_all do |entry|
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