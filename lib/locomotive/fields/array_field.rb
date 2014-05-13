require_relative 'abstract_field'

module Locomotive
  module Fields
    class ArrayField < AbstractField

      def value= _values
        @value = _values.map { |object| object.class == klass ? object : klass.new(object) }
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
