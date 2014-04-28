module Locomotive
  module Common

    class Configuration
      attr_accessor :default_adapter

      def initialize
        @default_adapter = Adapters::MemoryAdapter.new
      end
    end

  end
end
