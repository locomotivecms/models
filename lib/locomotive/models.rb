# Force encoding to UTF-8
Encoding.default_internal = Encoding.default_external = 'UTF-8'

# Remove I18n warnings
require 'i18n'
I18n.config.enforce_available_locales = true

require 'active_support'
require 'active_support/core_ext'

require_relative 'core_ext'
require_relative 'entity'

Dir[File.dirname(__FILE__) + '/entities/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/presenters/*.rb'].each { |file| require file }

require_relative 'mapper'
require_relative 'mapping'
require_relative 'repository'

Dir[File.dirname(__FILE__) + '/repositories/*.rb'].each { |file| require file }

require_relative 'adapters/memory_adapter'
require_relative 'models/configuration'

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

    def self.mapper _mapper = nil
      if _mapper
        @mapper = _mapper
      else
        @mapper
      end
    end
  end
end

# Locomotive::Common.reset
# Locomotive::Common.configure do |config|
#   path = File.join(File.expand_path('log/models.log'))
#   config.notifier = Locomotive::Common::Logger.setup(path)
# end
# Locomotive::Common::Logger.info 'Models...'
