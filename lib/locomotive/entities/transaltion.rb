require_relative '../entity'

module Locomotive
  module Entities
    class Translation < Entity

      ## fields ##
      field :key
      field :values

      ## methods ##

      def get(locale)
        self.values[locale.to_s]
      end

      def to_params
        { key: self.key, values: self.values }
      end

      def to_s
        "Translation {#{self.key}: #{self.values}}"
      end

    end
  end
end
