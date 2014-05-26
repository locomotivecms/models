module Locomotive
  class Mapper

    class UnknownCollection < StandardError ; end
    class << self
      def load!(file)
        self.new do
          instance_eval File.read(file), file
        end
      end
    end

    attr_reader :collections

    def initialize(&blk)
      @collections = {}
      instance_eval(&blk) if block_given?
    end

    def collection(name, &blk)
      if block_given?
        @collections[name] = Mapping::Collection.new(name, &blk)
      else
        @collections[name] or raise UnknownCollection
      end
    end
  end

end
