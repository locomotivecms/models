module Locomotive
  module Mapping

    class Collection

      REPOSITORY_SUFFIX = 'Repository'.freeze

      attr_reader :name
      attr_reader :coercer_class
      attr_reader :attributes

      def initialize(mapper, name, coercer_class, &blk)
        @name, @coercer_class, @attributes = name, coercer_class, {}
        @mapper = mapper

        instance_eval(&blk) if block_given?

        load!
      end

      # TODO Should be guessed too
      def repository(klass = nil)
        if klass
          @repository = klass.new @mapper
        else
          @repository
        end
      end

      def entity(klass = nil)
        if klass
          @entity = klass
        else
          @entity
        end
      end

      def identity(name = nil)
        if name
          @identity = name
        else
          @identity || :id
        end
      end

      def attribute(name, options = {})
        @attributes[name] = options
      end

      def serialize(entity, locale)
        @coercer.to_record(entity, locale)
      end

      def deserialize(records, locale)
        records.map do |record|
          @coercer.from_record(record, locale)
        end
      end

      private

      def load!
        @coercer = coercer_class.new(self)
      end

    end
  end
end
