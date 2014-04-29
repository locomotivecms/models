require_relative 'locomotive/core_ext'
require_relative 'locomotive/entities'
require_relative 'locomotive/mapping'
require_relative 'locomotive/datastore'
require_relative 'locomotive/mounting_point'
require_relative 'locomotive/repository'
require_relative 'locomotive/repositories/site_repository'
require_relative 'locomotive/adapters/memory_adapter'

require_relative 'locomotive/models/configuration'

module Locomotive
  module Models
    class << self
      attr_writer :configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.reset
      @configuration = Configuration.new
    end

    def self.configure
      yield(configuration)
    end
  end
end
