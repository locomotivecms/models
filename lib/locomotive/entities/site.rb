module Locomotive
  module Entities
    class Site < Hash

      class << self
        def attributes
          [ :name, :subdomain, :domains, :locales, :seo_title,
            :meta_keywords, :meta_description, :description ]
        end
      end

      attr_accessor *self.attributes

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
