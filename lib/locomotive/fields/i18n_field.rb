require_relative 'abstract_field'

module Locomotive
  module Fields
    class I18nField < AbstractField


      def translations
        @translations ||= {}
      end

      def locales
        @locales ||= []
      end

      def value= _translations
        unless _translations.respond_to?(:to_hash)
          raise UnsupportedFormat.new('Please use Hash { locale: value } or I18nField class')
        end
        _translations.to_hash.each do |locale, value|
          add_locale locale
          self.translations[locale] = value
        end
      end

      def value
        self.translations
      end
      alias :to_hash :value

      private

      def add_locale locale
        locales << locale unless self.locales.include?(locale)
      end
    end
  end
end
