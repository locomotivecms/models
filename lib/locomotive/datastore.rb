module Locomotive

  class Datastore

    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    def adapter
      @options[:adapter] || default_adapter
    end

    def default_adapter
      @default_adapter ||= Locomotive::Models.configuration.default_adapter
    end

  end

end
