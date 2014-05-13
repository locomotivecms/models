module Locomotive
  module Entities
    class Page
      include Locomotive::Entity

      ## fields ##
      attributes :parent, :title, :slug, :fullpath, :redirect_url, :redirect_type, 
                 :template, :handle, :listed, :searchable, :templatized, :content_type, 
                 :published, :cache_strategy, :response_type, :position, :seo_title, 
                 :meta_keywords, :meta_description, :editable_elements

      ## aliases ##
      alias :listed?      :listed
      alias :published?   :published
      alias :templatized? :templatized
      alias :searchable?  :searchable

    end
  end
end
