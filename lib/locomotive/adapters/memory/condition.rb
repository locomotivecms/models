module Locomotive
  module Adapters
    module Memory

      class Condition

        OPERATORS = %w(all gt gte in lt lte ne nin size).freeze

        attr_accessor :name, :operator, :right_operand

        def initialize(name, value)
          self.name, self.right_operand = name, value

          self.process_right_operand

          # default value
          self.operator = :==

          self.decode_operator_based_on_name
        end

        def matches?(entry)
          value = self.get_value(entry)

          self.decode_operator_based_on_value(value)

          case self.operator
          when :==      then value == self.right_operand
          when :ne      then value != self.right_operand
          when :matches then self.right_operand =~ value
          when :gt      then value > self.right_operand
          when :gte     then value >= self.right_operand
          when :lt      then value < self.right_operand
          when :lte     then value <= self.right_operand
          when :size    then value.size == self.right_operand
          when :all     then array_contains?([*self.right_operand], value)
          when :in, :nin
            _matches = if value.is_a?(Array)
              array_contains?([*value], [*self.right_operand])
            else
              [*self.right_operand].include?(value)
            end
            self.operator == :in ? _matches : !_matches
          else
            raise UnknownConditionInScope.new("#{self.operator} is unknown or not implemented.")
          end
        end

        def to_s
          "#{name} #{operator} #{self.right_operand.to_s}"
        end

        protected

        def get_value(entry)
          value = entry.send(self.name)

          if value.respond_to?(:_slug)
            # belongs_to
            value._slug
          elsif value.respond_to?(:map)
            # many_to_many or tags ?
            value.map { |v| v.respond_to?(:_slug) ? v._slug : v }
          else
            value
          end
        end

        def process_right_operand
          if self.right_operand.respond_to?(:_slug)
            # belongs_to
            self.right_operand = self.right_operand._slug
          elsif self.right_operand.respond_to?(:map) && self.right_operand.first.respond_to?(:_slug)
            # many_to_many
            self.right_operand = self.right_operand.map do |entry|
              entry.try(&:_slug)
            end
          end
        end

        def decode_operator_based_on_name
          if match = name.match(/^(?<name>[a-z0-9_-]+)\.(?<operator>#{OPERATORS.join('|')})$/)
            self.name     = match[:name].to_sym
            self.operator = match[:operator].to_sym
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

        def array_contains?(source, target)
          source & target == target
        end

      end

    end
  end
end
