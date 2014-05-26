require 'delegate'

module Locomotive
  module Mapping
    class AssociationPlaceholder < BasicObject

      attr_reader :locale

      def initialize id_or_entity, locale, &block
        @id_or_entity, @locale = id_or_entity, locale
        @loaded_block = block
      end

      def id
        if @id_or_entity.respond_to?(:id)
          @id_or_entity.id
        else
          @id_or_entity
        end
      end

      def repository=(repo)
        @repository = repo
      end
      def method_missing(name, *args, &block)
        __load__
        @object.public_send(name, *args, &block)
      end

      private

      def __load__
        @object ||= @repository.find(id, locale)
        @loaded_block.call(@object)
      end
    end
  end
end
