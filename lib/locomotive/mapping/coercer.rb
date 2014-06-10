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
              _attributes[name] = to_locale(entity.send(name))
            elsif options[:association]
              Referencer.new(@collection, _attributes, name, options, entity.send(name)).reference!
            else
              _attributes[name] = entity.send(name)
            end
          end
        end
      end

      def from_record(record)
        @collection.entity.new(id: record[:id]).tap do |_entity|
          @collection.attributes.each do |name, options|
            value = if options[:localized]
              Fields::I18nField.new(record[name])
            elsif options[:association]
              Dereferencer.new(_entity, name, options, record[name]).deference!
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

      protected

      def to_locale(content)
        case content
        when Fields::I18nField
          content.i18n_values
        when nil
          {}
        else
          raise Fields::I18nField::UnsupportedFormat
            .new('Localized field needs Fields::I18nField, please use << instead of =')
        end
      end

    end
  end
end
