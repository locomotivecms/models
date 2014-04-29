module Locomotive
  module Entities
    class Site < Hash
      attr_accessor :name, :subdomain, :domains, :locales, :seo_title, :meta_keywords, :meta_description, :description

      def initialize hash
        [ :name, :subdomain, :domains, :locales, :seo_title,
          :meta_keywords, :meta_description, :description].each do |attribute|

          self.send(:"#{attribute}=", hash.send(attribute)) rescue NoMethodError
        end
      end

      def to_s
        str = '{'
        str += [ :name, :subdomain, :domains, :locales, :seo_title,
          :meta_keywords, :meta_description, :description].map do |attribute|
            ":#{attribute} => #{self.send(attribute)}"
        end.join(', ')
        str += '}'
      end
      alias_method :inspect, :to_s
    end
  end
end
