module Locomotive
  module Fields
    class I18nField

      class UnsupportedFormat < StandardError ; end

      class I18nValues < Hash
        def method_missing method_name, *args
          return self.fetch(method_name) if self.has_key?(method_name)
          super
        end
      end

      attr_accessor :i18n_values
      # alias :values= :i18n_values=
      alias :values  :i18n_values

      def initialize i18n_values = nil, _current_locale = nil
        @i18n_values = I18nValues.new
        self.current_locale = _current_locale
        self << i18n_values
      end

      def << i18n_values
        i18n_values && @i18n_values.merge!(i18n_values)

      rescue TypeError
        raise UnsupportedFormat.new("waiting format: { locale: value } not ''#{i18n_values}''")
      end

      def remove locale
        @i18n_values.delete locale
      end

      def locales
        @i18n_values.keys
      end

      def current_locale= locale
        @current_locale = locale.try(:to_sym)
      end

      def current_locale
        @current_locale ||= i18n_values.keys.first
      end

      def to_s locale = nil
        if (str = i18n_values.fetch(locale) { i18n_values[current_locale] })
          str
        else
          "#<Foo: @i18n_values=>{" + i18n_values.map{|k,v|":#{k}=>#{v}"}.join(',') + '}>'
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
