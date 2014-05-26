module Locomotive
  module Mapping
    class AssociationPlaceholder

      attr_reader :locale

      def initialize name, id_or_entity, locale
        @name, @id_or_entity, @locale = name, id_or_entity, locale
      end

      def id
        if @id_or_entity.respond_to?(:id)
          @id_or_entity.id
        else
          @id_or_entity
        end
      end
    end
  end
end
