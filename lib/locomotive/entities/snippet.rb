require_relative '../entity'

module Locomotive
  module Entities
    class Snippet < Entity

      ## fields ##
      field :name
      field :slug

      field :template, localized: true

      ## methods ##

      # Return the Liquid template based on the template_filepath property
      # of the snippet. If the template is HAML, then a pre-rendering to Liquid is done.
      #
      # @return [ String ] The liquid template
      #
      # TODO move this out of models to Steam
      def source(locale)
        @source ||= {}
        @source[locale] ||= begin
          if template[locale].respond_to?(:source)
            # liquid or haml file
            template[locale].source
          else
            # simple string
            template[locale]
          end
        end
      end

      # Return the params used for the API.
      #
      # @return [ Hash ] The params
      #
      def to_params(locale)
        params = self.filter_attributes %w(name slug)

        # raw_template
        params[:template] = self.source(locale) # rescue nil

        params
      end

      def to_s
        self.name
      end

    end
  end
end
