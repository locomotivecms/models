module Locomotive
  module Adapters
    module Memory

      class Condition

        class UnsupportedOperator < StandardError; end

        OPERATORS = %i(== eq ne neq matches gt gte lt lte size all in nin).freeze

        attr_accessor :name, :operator, :right_operand, :locale

        def initialize(name, value, locale)
          self.locale = locale
          self.name, self.right_operand = name, value
          # default value
          self.operator = :==
          self.decode_operator_based_on_name
        end

        def matches?(entry)
          value = self.get_value(entry)

          self.decode_operator_based_on_value(value)

          case self.operator
          when :==        then value == self.right_operand
          when :eq        then value == self.right_operand
          when :ne        then value != self.right_operand
          when :neq       then value != self.right_operand
          when :matches   then self.right_operand =~ value
          when :gt        then value > self.right_operand
          when :gte       then value >= self.right_operand
          when :lt        then value < self.right_operand
          when :lte       then value <= self.right_operand
          when :size      then value.size == self.right_operand
          when :all       then array_contains?([*self.right_operand], value)
          when :in, :nin  then value_in_right_operand?(value)
          else
            raise UnknownConditionInScope.new("#{self.operator} is unknown or not implemented.")
          end
        end

        def to_s
          "#{name} #{operator} #{self.right_operand.to_s}"
        end

        protected

        def get_value(entry)
          case (value = entry.send(self.name))
          when Hash
            value.fetch(self.locale.to_s)
          else
            value
          end
        end

        def decode_operator_based_on_name
          if match = name.match(/^(?<name>[a-z0-9_-]+)\.(?<operator>.*)$/)
            self.name     = match[:name].to_sym
            self.operator = match[:operator].to_sym
            unless OPERATORS.include? self.operator
              raise UnsupportedOperator.new
            end
          end

          if self.right_operand.is_a?(Regexp)
            self.operator = :matches
          end
        end

        def decode_operator_based_on_value(value)
          case value
          when Array
            self.operator = :in if self.operator == :==
          end
        end

        def value_in_right_operand?(value)
          _matches = if value.is_a?(Array)
            array_contains?([*value], [*self.right_operand])
          else
            [*self.right_operand].include?(value)
          end
          self.operator == :in ? _matches : !_matches
        end

        def array_contains?(source, target)
          source & target == target
        end

      end

    end
  end
end
