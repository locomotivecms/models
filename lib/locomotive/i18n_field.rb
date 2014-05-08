module Locomotive
  class I18nField

    class UnsupportedFormat < StandardError ; end

    attr_accessor :locales, :translations

    def initialize translations={}
      @translations = translations.to_hash
      @locales = []
      initialize_locales
    end

    def value= _translations
      unless _translations.respond_to?(:to_hash)
        raise UnsupportedFormat.new('Please use Hash { locale: value } or I18nField class')
      end
      _translations.to_hash.each do |locale, value|
        add_locale locale
        translation = { locale => self.translations.delete(locale) }
        translation[locale] = value
        self.translations.merge!(translation)
      end
      _translations
    end

    def value locale
      self.translations.fetch( locale ) { nil }
    end

    def to_hash
      self.translations
    end

    def to_str locale=nil
      return self.translations.values.first unless locale
      self.translations.fetch( locale ) { nil }
    end
    alias :to_s :to_str

    private

    def add_locale locale
      locales << locale unless self.locales.include?(locale)
    end

    def initialize_locales
      self.translations.keys.each do |locale|
        add_locale locale
      end
    end

  end
end
