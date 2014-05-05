require_relative '../entity'

module Locomotive
  module Entities
    class ContentType < Entity

      class << self
        def attributes
          [:name, :description, :slug, :order_by]
        end
      end

      attr_accessor *attributes
      def initialize hash
        self.class.attributes.each do |attribute|
          self.send(:"#{attribute}=", hash.send(attribute)) rescue NoMethodError
        end
      end

      def to_s
        str = '{'
        str += self.class.attributes.map do |attribute|
            ":#{attribute} => #{self.send(attribute)}"
        end.join(', ')
        str += '}'
      end
      alias_method :inspect, :to_s
    end
  end
end
