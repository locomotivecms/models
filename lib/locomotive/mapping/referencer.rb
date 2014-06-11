module Locomotive
  module Mapping
    class Referencer < Struct.new(:collection, :attributes, :name, :options, :value)

      def reference!
        return unless value

        Array(value).each do |entity| fill_associations! entity end

        case value
        when Array
          attributes[name] = value.map(&:id)
        else
          attributes[name] = value.id
        end
      end

      private

      def assign_parent_reference! entity
        raise "Please persit parent object first" unless attributes[:id]

        identity_reference_field = options[:association].fetch(:key) # article_id
        entity.send :"#{identity_reference_field}=", attributes[:id]
      end

      def assign_child_reference! entity
        identity_reference_field = options[:association].fetch(:key)
        attributes[identity_reference_field] = identity(entity)
      end

      def fill_associations! entity
        type = options[:association].fetch(:type)

        if type == :has_many
          assign_parent_reference! entity
          if persisted? entity
            Locomotive::Models[options[:association].fetch(:name)].update entity # save reference
          else
            Locomotive::Models[options[:association].fetch(:name)].create entity # save reference
          end
        else # belongs_to
          assign_child_reference! entity
        end
      end

      def identity entity
        persist!(entity) if persisted?(entity)
        entity.id
      end

      def persisted? entity
        entity.id
      end

      def persist! entity
        Locomotive::Models[options[:association].fetch(:name)].update entity
      end

      def reference_field
        collection.name[0..-2] + '_id'
      end

    end
  end
end
