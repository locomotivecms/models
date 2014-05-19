module Locomotive
  module Entities
    class ContentEntry
      include Locomotive::Entity

      ## fields ##
      attributes  :_slug,:_position,:_visible,:seo_title,:meta_keywords,:meta_description,
                  :content_type, :dynamic_attributes, :main_locale, :errors

      alias :_permalink :_slug
      alias :_permalink= :_slug=

    end
  end
end
