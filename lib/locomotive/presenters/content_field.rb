module Locomotive
  module Presenters
    class ContentField

      def initialize entity, context
        @entity, @context = entity, context
      end

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