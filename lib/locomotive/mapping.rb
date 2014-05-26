require_relative 'mapping/collection'
require_relative 'mapping/coercer'

module Locomotive
  module Mapping

    class UnmappedCollectionError < ::StandardError
      def initialize(name)
        super("Cannot find collection: #{ name }")
      end
    end
  end
end
