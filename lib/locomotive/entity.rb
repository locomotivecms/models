module Locomotive
  class Entity < Hash

    class << self
      def attributes
        raise NotImplementedError
      end
    end

    def to_record
      self
    end

  end
end
