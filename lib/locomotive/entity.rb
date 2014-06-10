module Locomotive
  module Entity

    attr_accessor :id

    def self.included(base)
      base.extend ClassMethods
    end

    def initialize attributes = {}
      attributes.each do |key, value|
        case value
        when Hash
          self.send "#{key}=", Locomotive::Fields::I18nField.new(value)
        else
          self.send "#{key}=", value
        end
      end
    end

    module ClassMethods

      def attributes *args
        attr_accessor(*args)
      end
    end
  end
end
