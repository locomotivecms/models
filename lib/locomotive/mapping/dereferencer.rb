module Locomotive
  module Mapping
    class Dereferencer < Struct.new(:entity, :name, :options, :value)

      def deference!
        case value
        when Array
          entity.send(:"#{name}=", Locomotive::Mapping::VirtualProxy.new do
            entity.send(:"#{name}=", entities_reference(value))
          end)
        else
          entity.send(:"#{name}=", Locomotive::Mapping::VirtualProxy.new do
            entity.send(:"#{name}=", entity_reference(value))
          end)
        end
      end

      private

      def entity_reference value
        Models[options[:association]].query do
          where('id.eq' => value)
        end
      end

      def entities_reference value
        Models[options[:association]].query do
          where('id.in' => value)
        end
      end

    end
  end
end
