module Locomotive
  class Mapper

    attr_reader :collections

    def initialize
      @collections = {}
    end

    def collection(name)
      @collections[name] = Mapping::Collection.new(name)
    end
  end
end
