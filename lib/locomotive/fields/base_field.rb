require_relative 'abstract_field'

module Locomotive
  module Fields
    class BaseField < AbstractField

      def value= _value
        @value = _value
      end

      def value
        @value
      end

      def to_s
        self.value.to_s
      end
    end
  end
end
