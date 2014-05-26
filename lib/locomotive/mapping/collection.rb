module Locomotive
  module Mapping
    class Collection

      attr_reader :attributes

      def initialize entity, &blk
        @coercer = Coercer.new(self)
        @attributes = {}
        instance_eval(&blk) if block_given?
      end

      def entity(klass = nil)
        if klass
          @entity = klass
        else
          @entity
        end
      end

      def attribute(name, options = {})
        @attributes[name] = options
      end

      def serialize(record, locale)

        @coercer.to_record(record, locale)
      end

      def deserialize(records, locale)
        
        records.map do |record|
          @coercer.from_record(record, locale)
        end
      end

    end
  end
end
