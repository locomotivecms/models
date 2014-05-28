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
            elsif options[:association]
              _attributes[name] = entity.send(name).try(:id)
            else
              _attributes[name] = entity.send(name)
            end
          end
        end
      end

      def from_record(record, locale)
        @collection.entity.new(id: record[:id]).tap do |_entity|
          @collection.attributes.each do |name, options|
            value = if options[:localized]
              record[name][locale]
            elsif options[:association]
              _entity.send(:"#{name}=", Locomotive::Mapping::VirtualProxy.new {
                  _entity.send(:"#{name}=",
                    Models.mapper.collection(options[:association]).repository.find(record[name], locale)
                  )
                }
              )
            else
              record[name]
            end

            if (klass = options.fetch(:klass, nil))
              _entity.send(:"#{name}=", klass.new(value))
            else
              _entity.send(:"#{name}=", value)
            end
          end
        end
      end
    end
  end
end
