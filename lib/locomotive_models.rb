# Force encoding to UTF-8
Encoding.default_internal = Encoding.default_external = 'UTF-8'

# Remove I18n warnings
require 'i18n'
I18n.config.enforce_available_locales = true

require 'active_support'
require 'active_support/core_ext'

require_relative 'locomotive/core_ext'

require_relative 'locomotive/fields'
Dir[File.dirname(__FILE__) + '/locomotive/entities/*.rb'].each { |file| require file }

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

    #     # default locale
    # @@locale = I18n.locale

    # def self.mount(options)
    #   @@mount_point = Locomotive::Mounter::Config[:reader].run!(options)
    # end

    def self.locale
      configuration.locale
    end

    def self.locale=(locale)
      configuration.locale = locale.to_sym
    end

    def self.with_locale(locale, &block)
      current_locale = configuration.locale
      yield.tap do
        configuration.locale = locale.try(:to_sym)
      end
    ensure
      configuration.locale = current_locale
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
