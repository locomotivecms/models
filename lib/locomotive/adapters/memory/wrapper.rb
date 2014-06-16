module Locomotive
  module Adapters
    module Memory

      class Wrapper < Struct.new(:query, :collection)

        def first
          all.first
        end

        def all
          collection.deserialize(query)
        end

        def constraints &block
          query.instance_eval(&block) if block_given?
          query
        end

      end
    end
  end
end
