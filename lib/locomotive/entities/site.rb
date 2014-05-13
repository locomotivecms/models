require_relative '../entity'

module Locomotive
  module Entities
    class Site < Entity

      ## fields ##
      field :name
      field :locales
      field :subdomain
      field :domains
      field :seo_title,         localized: true
      field :meta_keywords,     localized: true
      field :meta_description,  localized: true
      field :robots_txt
      field :timezone

      ## methods ##

      def to_s
        self.name
      end

    end
  end
end
