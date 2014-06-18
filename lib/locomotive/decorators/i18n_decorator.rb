module Locomotive
  module Decorators
    class I18nDecorator < SimpleDelegator

      attr_accessor :current_locale
      attr_writer :on_no_locale, :on_empty_locale

      class << self
        def decorate(resultset, locale = nil)
          resultset.map { |obj| new(obj).tap {|decorated_obj| decorated_obj.current_locale = locale} }
        end
      end

      def initialize(object, locale = nil)
        self.current_locale = locale
        super(object)
      end

      def current_locale= _locale
        @current_locale = _locale.try(:to_sym)
      end

      def method_missing(name, *args, &block)
        begin
          __getobj__.public_send(name).to_s(current_locale)
        rescue Locomotive::Fields::I18nField::NoLocaleError
          on_no_locale.call __getobj__.send(name), current_locale
        rescue Locomotive::Fields::I18nField::EmptyLocaleError
          on_empty_locale.call __getobj__.send(name), current_locale
        rescue ArgumentError, TypeError
          super
        end
      end

      def on_no_locale
        @on_no_locale ||= Proc.new { |field, locale| nil }
      end

      def on_empty_locale
        @on_empty_locale ||= Proc.new { |field, locale| field.values.first }
      end

    end
  end
end
