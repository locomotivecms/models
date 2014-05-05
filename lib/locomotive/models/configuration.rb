module Locomotive
  module Models

    class Configuration
      attr_accessor :default_adapter, :default_loader, :locale

      def initialize
        self.default_adapter = Adapters::MemoryAdapter.new
        self.default_loader  = Adapters::Memory::EmptyLoader.new
        self.locale = :en
      end
    end

  end
end
