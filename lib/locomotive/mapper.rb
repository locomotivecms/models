module Locomotive
  class Mapper

    class << self
      def load_from_file!(file)
        self.new do
          instance_eval File.read(file), file
        end
      end
    end

    attr_reader :collections

    def initialize(coercer = nil, &blk)
      @coercer     = coercer || Mapping::Coercer
      @collections = {}
      instance_eval(&blk) if block_given?
    end

    def collection(name, &blk)
      if block_given?
        @collections[name] = Mapping::Collection.new(name, @coercer, &blk)
      else
        @collections[name] or raise Mapping::UnmappedCollectionError.new(name)
      end
    end

    def load!
      @collections.each_value { |collection| collection.load! }
      self
    end
  end

end
