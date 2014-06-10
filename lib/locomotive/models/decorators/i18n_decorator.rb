module Locomotive
  module Decorators
    class I18nDecorator < SimpleDelegator

      attr_accessor :current_locale
      class << self
        def decorate(resultset, locale = nil)
          resultset.map { |obj| new(obj).tap {|decorated_obj| decorated_obj.current_locale = locale} }
        end
      end

      def initialize(object, locale = nil)
        self.current_locale = locale
        super(object)
      end

      def method_missing(name, *args, &block)
        begin
          __getobj__.public_send(name)[current_locale]
        rescue TypeError
          super
        end
      end

    end
  end
end
