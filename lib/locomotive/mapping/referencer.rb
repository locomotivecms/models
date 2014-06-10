module Locomotive
  module Mapping
    class Referencer < Struct.new(:collection, :attributes, :name, :options, :value)

      def reference!
        return unless value

        Array(value).each do |entity| persist! entity end

        case value
        when Array
          attributes[name] = value.map(&:id)
        else
          attributes[name] = value.id
        end
      end

      private

      def assign_parent_reference! entity
        binding.pry unless attributes[:id]
        raise "Please persit parent object first" unless attributes[:id]
        entity.instance_variable_set("@#{reference_field}", attributes[:id])
        # entity.instance_variable_set('@foreign_id', attributes[:id])
        # entity.define_singleton_method(reference_field.to_sym) do
        #   @foreign_id
        # end
      end

      def persist! entity
        assign_parent_reference! entity

        if persisted? entity
          Locomotive::Models[options[:association]].update entity
        else
          Locomotive::Models[options[:association]].create entity
        end
      end

      def persisted? entity
        entity.id
      end

      def reference_field
        collection.name[0..-2] + '_id'
      end

    end
  end
end
