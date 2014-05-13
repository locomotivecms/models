module Locomotive
  module Entities
    class Snippet
      include Locomotive::Entity

      ## fields ##
      attributes :name, :slug, :template

    end
  end
end
