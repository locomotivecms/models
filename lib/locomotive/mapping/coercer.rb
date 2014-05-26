module Locomotive
  module Mapping
    class Coercer

      def initialize(collection)
        @collection = collection
      end

      def to_record(entity, locale)
        {}.tap do |_attributes|
          _attributes[:id] = entity.id
          @collection.attributes.each do |name, options|
            if options[:localized]
              _attributes[name] = { locale => entity.send(name) }
            else
              _attributes[name] = entity.send(name)
            end
          end
        end
      end

      def from_record(record, locale)

        _entity = @collection.entity.new(id: record[:id])

        @collection.attributes.each do |name, options|
          
          if options[:localized]
            _entity.send(:"#{name}=", record[name][locale])
          else
            _entity.send(:"#{name}=", record[name])
          end
        end
        _entity
      end

    end
  end
end
