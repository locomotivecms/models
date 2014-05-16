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

      attr_accessor :templatized_from_parent


      # Tell if the page is either the index page.
      #
      # @return [ Boolean ] True if index page.
      #
      def index?
        'index' == fullpath
      end

      # Tell if the page is either the index or the 404 page.
      #
      # @return [ Boolean ] True if index or 404 page.
      #
      def index_or_404?
        %w(index 404).include?(fullpath)
      end

      # Depth of the page in the site tree.
      # Both the index and 404 pages are 0-depth.
      #
      # @return [ Integer ] The depth
      #
      def depth
        return 0 if %w(index 404).include?(self.fullpath)
        fullpath.split('/').size
      end

      # Modified setter in order to set correctly the slug
      #
      # @param [ String ] fullpath The fullpath
      #
      def fullpath_with_setting_slug=(fullpath)
        if fullpath && self.slug.nil?
          self.slug = File.basename(fullpath)
        end

        self.fullpath_without_setting_slug = fullpath
      end

      alias_method_chain :fullpath=, :setting_slug

      # Modified setter in order to set inheritance fields from parent
      #
      # @param [ String ] fullpath The fullpath
      #
      def parent_with_inheritance=(parent)
        self.templatized_from_parent = parent.templatized?

        # copy properties from the parent
        %w(templatized content_type).each do |name|
          self.send(:"#{name}=", parent.send(name.to_sym))
        end

        self.parent_without_inheritance = parent
      end
      alias_method_chain :parent=, :inheritance


      # Return the fullpath dasherized and with the "*" character
      # for the slug of templatized page.
      #
      # @return [ String ] The safe full path or nil if the page is not translated in the current locale
      #
      def safe_fullpath
        if index_or_404?
          slug
        else
          base  = parent.safe_fullpath
          _slug = if templatized? && !templatized_from_parent
            '*'
          else
            slug
          end
          (base == 'index' ? _slug : File.join(base, _slug)).dasherize
        end
      end

    end
  end
end
