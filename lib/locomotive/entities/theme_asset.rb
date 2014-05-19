module Locomotive
  module Entities
    class ThemeAsset
      include Locomotive::Entity

      PRECOMPILED_CSS_TYPES     = %w(sass scss less)

      PRECOMPILED_JS_TYPES      = %w(coffee)

      PRECOMPILED_FILE_TYPES    = PRECOMPILED_CSS_TYPES + PRECOMPILED_JS_TYPES

      CSS_JS_SHORT_PATH_REGEXP  = /^(javascripts|stylesheets|fonts)\/(.*)$/

      ## fields ##
      attributes :folder

      ## other accessors ##
      attr_accessor :filepath, :uri, :size
    end
  end
end
