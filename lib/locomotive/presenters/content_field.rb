module Locomotive
  module Presenters
    class ContentSelectOption

      def initialize collection
        @collection = collection
      end

      def to_hash
        locales = @collection.map { |option| option.name.keys }.flatten.uniq
        options = @collection.sort { |a, b| a.position <=> b.position }
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