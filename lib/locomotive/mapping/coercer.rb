module Locomotive
  module Mapping
    class Coercer

      def initialize(collection)
        @collection = collection
      end

      def to_record(entity)
        {}.tap do |_attributes|
          _attributes[:id] = entity.id
          @collection.attributes.each do |name, options|
            if options[:localized]
              _attributes[name] = { @collection.locale => entity.send(name) }
            else
              _attributes[name] = entity.send(name)
            end
          end
        end
      end

      def from_record(record)

        _entity = @collection.entity.new(id: record[:id])

        @collection.attributes.each do |name, options|
          
          if options[:localized]
            _entity.send(:"#{name}=", record[name][@collection.locale])
          else
            _entity.send(:"#{name}=", record[name])
          end
        end
        _entity
      end

    end
  end
end
