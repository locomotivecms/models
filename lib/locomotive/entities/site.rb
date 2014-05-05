require_relative '../entity'

module Locomotive
  module Entities
    class Site < Entity

      class << self
        def attributes
          [ :name, :subdomain, :domains, :locales, :seo_title,
            :meta_keywords, :meta_description, :description ]
        end
      end

      attr_accessor *self.attributes

    end
  end
end
