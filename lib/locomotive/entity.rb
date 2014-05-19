module Locomotive
  module Entity

    def self.included(base)
      base.extend ClassMethods
    end

    def initialize attributes = {}
      attributes.each { |k, v| self.send "#{k}=", v }
    end

    module ClassMethods

      def attributes *args
        attr_accessor(*args)
      end
    end
  end
end
