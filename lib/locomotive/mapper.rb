module Locomotive
  class Mapper

    attr_reader :collections

    def initialize(&blk)
      @collections = {}
      instance_eval(&blk) if block_given?
    end

    def collection(name, locale, &blk)
      if block_given?
        @collections[name] = Mapping::Collection.new(name, locale, &blk)
      else
        @collections[name] or raise StandardError.new
      end
    end
  end

end
