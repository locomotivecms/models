module Locomotive
  module Mapping
    class Dereferencer < Struct.new(:entity, :name, :options, :record)

      def deference!
        case value
        when Array
          entity.send(:"#{name}=", Locomotive::Mapping::VirtualProxy.new do
            entity.send(:"#{name}=", entities_reference(value))
          end)
        else
          entity.send(:"#{name}=", Locomotive::Mapping::VirtualProxy.new do
            entity.send(:"#{name}=", entity_reference(record[options[:association].fetch(:key)]))
          end)

          entity.send(:"#{options[:association].fetch(:key)}=", record[options[:association].fetch(:key)])
        end
      end

      private

      def value
        record[name]
      end

      def entity_reference value
        Models[options[:association].fetch(:name)].query do
          where('id.eq' => value)
        end.all.first
      end

      def entities_reference value
        Models[options[:association].fetch(:name)].query do
          where('id.in' => value)
        end.all
      end

    end
  end
end
