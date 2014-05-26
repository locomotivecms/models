module Locomotive
  module Mapping

    class Collection

      REPOSITORY_SUFFIX = 'Repository'.freeze

      attr_reader :name
      attr_reader :coercer_class
      attr_reader :attributes

      def initialize(name, coercer_class, &blk)
        @name, @coercer_class, @attributes = name, coercer_class, {}
        instance_eval(&blk) if block_given?
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

      def load!
        @coercer = coercer_class.new(self)
        configure_repository!
      end


      private

      def configure_repository!
        repository = Object.const_get("#{ entity.name }#{ REPOSITORY_SUFFIX }")
        repository.collection = name
      rescue NameError
      end

    end
  end
end
