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
            if options[:association]
              Dereferencer.new(_entity, name, options, record).deference!
            elsif options[:localized]
              _entity.send(:"#{name}=", Fields::I18nField.new(record[name]))
            else
              _entity.send(:"#{name}=", cast(record[name], options))
            end
          end
        end
      end

      protected

      def cast value, options
        if (klass = options.fetch(:klass, nil))
          klass.new(value)
        else
          value
        end
      end

      def to_locale(content)
        case content
        when Fields::I18nField
          content.i18n_values
        else
          raise Fields::I18nField::UnsupportedFormat
            .new('Localized field needs Fields::I18nField, please use << instead of =')
        end
      end

    end
  end
end
