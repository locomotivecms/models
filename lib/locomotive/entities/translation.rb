module Locomotive
  module Entities
    class Translation
      include Locomotive::Entity

      ## fields ##
      attributes :key, :values

    end
  end
end
