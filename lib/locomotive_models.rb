# Force encoding to UTF-8
Encoding.default_internal = Encoding.default_external = 'UTF-8'

# Remove I18n warnings
require 'i18n'
I18n.config.enforce_available_locales = true

require 'active_support'
require 'active_support/core_ext'

require_relative 'locomotive/core_ext'

require_relative 'locomotive/entity'

require_relative 'locomotive/fields'
Dir[File.dirname(__FILE__) + '/locomotive/fields/*.rb'].each { |file| require file }

Dir[File.dirname(__FILE__) + '/locomotive/entities/*.rb'].each { |file| require file }

Dir[File.dirname(__FILE__) + '/locomotive/presenters/*.rb'].each { |file| require file }

require_relative 'locomotive/mapper'
require_relative 'locomotive/mapping'
require_relative 'locomotive/datastore'
require_relative 'locomotive/mounting_point'
require_relative 'locomotive/repository'

Dir[File.dirname(__FILE__) + '/locomotive/repositories/*.rb'].each { |file| require file }

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

# Locomotive::Common.reset
# Locomotive::Common.configure do |config|
#   path = File.join(File.expand_path('log/models.log'))
#   config.notifier = Locomotive::Common::Logger.setup(path)
# end
# Locomotive::Common::Logger.info 'Models...'
