module Locomotive
  module Fields
    class I18nField

      class UnsupportedFormat < StandardError ; end
      class NoLocaleError < StandardError ; end
      class EmptyLocaleError < StandardError ; end

      class I18nValues < Hash
        def method_missing method_name, *args
          return self.fetch(method_name) if self.has_key?(method_name)
          super
        end
      end

      attr_accessor :i18n_values

      def values
        i18n_values.values
      end

      def each(&block)
        i18n_values.each(&block)
      end

      def initialize i18n_values = nil
        @i18n_values = I18nValues.new
        self << i18n_values
      end

      def << _i18n_values
        i18n_values && @i18n_values.merge!(_i18n_values.symbolize_keys)

      rescue TypeError
        raise UnsupportedFormat.new("waiting format: { locale: value } not ''#{i18n_values}''")
      end

      def remove locale
        @i18n_values.delete locale
      end

      def locales
        @i18n_values.keys
      end

      def to_s locale = nil
        if locale
          i18n_values.fetch(locale) do
            raise NoLocaleError
          end.tap do |value|
            raise EmptyLocaleError if value.empty?
          end
        else
          "#<I18nField: @i18n_values=>{" + i18n_values.map{|k,v|":#{k}=>#{v}"}.join(',') + '}>'
        end
      end
      alias_method :inspect, :to_s

      def [] (locale)
        send locale
      end

      def method_missing method_name, *args
        return i18n_values.send(method_name) if i18n_values.has_key?(method_name)
        super
      end

    end
  end
end
