module Locomotive
  module Fields
    class ArrayField < AbstractField

      def value= _values
        @value = _values.map { |object| object.respond_to?(:to_hash) ? klass.new(object.to_hash) : object }
      end

      def value
        @value
      end

      def to_s
        self.value.inspect
      end

      private

      def klass
        @klass ||= self.options[:class_name].constantize
      end

    end
  end
end
