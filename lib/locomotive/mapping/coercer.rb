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
              case entity.send(name)
              when Array
                entity.send(name).each do |associated_entity|
                  unless associated_entity.id # Non persisted
                    Locomotive::Models[name].create associated_entity
                  end
                end
                _attributes[name] = entity.send(name).map(&:id)
              else
                associated_entity = entity.send(name)
                if associated_entity
                  unless associated_entity.id # Non persisted
                    Locomotive::Models[options[:association]].create associated_entity
                  end
                  _attributes[name] = associated_entity.id
                end
              end
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
              case record[name]
              when Array
                _entity.send(:"#{name}=", Locomotive::Mapping::VirtualProxy.new {
                    _entity.send(:"#{name}=", begin
                      Models[options[:association]].query do
                        where('id.in' => record[name])
                      end
                    end)
                  }
                )
              else
                if record[name]
                  _entity.send(:"#{name}=", Locomotive::Mapping::VirtualProxy.new {
                      _entity.send(:"#{name}=",
                        Models[options[:association]].find(record[name])
                      )
                    }
                  )
                end
              end
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
        else
          raise Fields::I18nField::UnsupportedFormat
            .new('Localized field needs Fields::I18nField, please use << instead of =')
        end
      end

    end
  end
end
