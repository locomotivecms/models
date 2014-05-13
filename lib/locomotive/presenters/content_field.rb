module Locomotive
  module Presenters
    class ContentField < Base

      def initialize entity, context
        @entity, @context = entity, context
      end

      # Instead of returning a simple hash, it returns a hash with name as the key and
      # the remaining attributes as the value.
      #
      # @return [ Hash ] A hash of hash
      #
      def to_hash
        hash = super.delete_if { |k, v| %w(name position).include?(k) }

        # class_name is chosen over class_slug
        if @entity.is_relationship?
          hash['class_name'] ||= hash['class_slug']
          hash.delete('class_slug')
        end

        # select options
        if @entity.type == :select
          hash['select_options'] = self.select_options_to_hash
        end

        { @entity.name => hash }
      end

      protected

      def select_options_to_hash
        locales = @entity.select_options.map { |option| option.name.keys }.flatten.uniq
        options = @entity.select_options.sort { |a, b| a.position <=> b.position }
        {}.tap do |by_locales|
          locales.each do |locale|
            options.each do |option|
              (by_locales[locale.to_s] ||= []) << option.name[locale]
            end
          end
        end
      end
    end
  end
end