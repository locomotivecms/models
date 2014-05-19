module Locomotive
  module Mapping
    class Collection

      attr_reader :locale, :attributes

      def initialize entity, locale, &blk
        @coercer = Coercer.new(self)
        @locale = locale
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

      def serialize(record)
        @coercer.to_record(record)
      end

      def deserialize(records)
        records.map do |record|
          @coercer.from_record(record)
        end
      end

    end
  end
end
