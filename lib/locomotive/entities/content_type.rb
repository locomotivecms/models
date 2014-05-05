require_relative '../entity'

module Locomotive
  module Entities
    class ContentType < Entity

      class << self
        def attributes
          [:name, :description, :slug, :order_by]
        end
      end

      attr_accessor *attributes

    end
  end
end
