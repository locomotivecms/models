module Locomotive
  module Entities
    class ContentType < Hash

      attr_accessor :name, :description, :slug, :order_by

      def initialize hash
        [ :name, :description, :slug, :order_by ].each do |attribute|
          self.send(:"#{attribute}=", hash.send(attribute)) rescue NoMethodError
        end
      end

      def to_s
        str = '{'
        str += [ :name, :description, :slug, :order_by ].map do |attribute|
            ":#{attribute} => #{self.send(attribute)}"
        end.join(', ')
        str += '}'
      end
      alias_method :inspect, :to_s
    end
  end
end
