# Force encoding to UTF-8
Encoding.default_internal = Encoding.default_external = 'UTF-8'

# Remove I18n warnings
require 'i18n'
I18n.config.enforce_available_locales = true

require 'active_support'
require 'active_support/core_ext'

require_relative 'core_ext'
require_relative 'entity'
require_relative 'mapper'
require_relative 'mapping'
require_relative 'repository'

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

    def self.[] name
      @mapper[name]
    end

    def self.mapper mapper = nil
      if mapper
        @mapper = mapper
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
