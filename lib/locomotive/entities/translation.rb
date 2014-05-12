require_relative '../entity'

module Locomotive
  module Entities
    class Translation < Entity

      ## fields ##
      field :key
      field :values, localized: true

    end
  end
end
