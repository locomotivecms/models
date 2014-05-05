module Locomotive
  class Entity < Hash

    class << self
      def attributes
        raise NotImplementedError
      end
    end

    def to_record
      self
    end

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
