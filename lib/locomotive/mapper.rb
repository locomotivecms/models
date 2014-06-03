module Locomotive
  class Mapper

    class << self
      def load_from_file!(adapter, file)
        self.new(adapter) do
          instance_eval File.read(file), file
        end
      end
    end

    attr_reader :collections, :adapter

    def initialize(adapter, coercer = nil, &blk)
      @coercer         = coercer || Mapping::Coercer
      @collections     = {}
      @adapter         = adapter.new self

      instance_eval(&blk) if block_given?

      registry!
    end

    def registry!
      Models.mapper self
    end

    def [] name
      collection(name.to_sym).repository
    end

    def collection(name, &blk)
      if block_given?
        @collections[name] = Mapping::Collection.new(self, name, @coercer, &blk)
      else
        @collections[name] or raise Mapping::UnmappedCollectionError.new(name)
      end
    end

  end
end
