module Locomotive
  module Models

    class Configuration
      attr_accessor :default_adapter

      def initialize
        self.default_adapter = Adapters::MemoryAdapter.new
      end
    end

  end
end
