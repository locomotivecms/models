module Locomotive
  module Models

    class Configuration
      attr_accessor :default_adapter, :default_loader

      def initialize
        self.default_adapter = Adapters::MemoryAdapter.new
        self.default_loader  = Adapters::Memory::EmptyLoader.new
      end
    end

  end
end
