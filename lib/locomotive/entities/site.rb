module Locomotive
  module Entities
    class Site
      include Locomotive::Entity

      attributes :name, :locales, :subdomain, :domains, :seo_title, 
                 :meta_keywords, :meta_description, :robots_txt, :timezone 
      ## methods ##

      def to_s
        self.name
      end

    end
  end
end
