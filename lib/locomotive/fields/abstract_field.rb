module Locomotive
  class AbstractField
    class UnsupportedFormat < StandardError ; end

    attr_accessor :options

    def initialize options={}
      self.options = options
    end

    def value= _values
      raise 'Not implemented'
    end

    def value
      raise 'Not implemented'
    end
  end
end
