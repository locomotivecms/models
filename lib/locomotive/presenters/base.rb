module Locomotive
  module Presenters

    class NilContext
      def locale
        false
      end
    end

    class Base
      attr_accessor :entity, :context

      def initialize(_entity, _context= nil)
        @entity, @context = _entity, (_context || NilContext.new )
      end

      # Return a Hash of all the non blank attributes of the object.
      # It also performs a couple of modifications: stringify keys and
      # convert Symbol to String.
      #
      # @param [ Boolean ] translation Flag (by default true) to get the translations too.
      #
      # @return [ Hash ] The non blank attributes
      #
      def to_hash
        hash = begin
          if context.locale
            localized_attributes
          else
            entity.attributes
          end          
        end
        hash.delete_if { |k, v| (!v.is_a?(FalseClass) && v.blank?) }
        hash.each { |k, v| hash[k] = v.to_s if v.is_a?(Symbol) }
        hash.deep_stringify_keys
      end

      # Provide a better output of the default to_yaml method
      #
      # @return [ String ] The YAML version of the object
      #
      def to_yaml
        # get the attributes with their translations and get rid of all the symbols
        object = self.to_hash

        object.each do |key, value|
          if value.is_a?(Array)
            object[key] = if value.first.is_a?(String)
              StyledYAML.inline(value) # inline array
            else
              value.map(&:to_hash)
            end
          end
        end

        StyledYAML.dump object
      end

    protected

      def localized_attributes
        {}.tap do |hsh|
          entity.attributes.each do |name, value|
            hsh[name] = entity.localized_field?(name) ? value[context.locale] : value
          end
        end
      end
    end
  end
end