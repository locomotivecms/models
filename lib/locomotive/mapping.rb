require_relative 'mapping/collection'
require_relative 'mapping/coercer'
require_relative 'mapping/association_placeholder'

module Locomotive
  module Mapping

    class UnmappedCollectionError < ::StandardError
      def initialize(name)
        super("Cannot find collection: #{ name }")
      end
    end
  end
end
