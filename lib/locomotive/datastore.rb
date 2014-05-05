module Locomotive

  class Datastore

    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    # Build a mounting point from a host name returned by request.
    #
    def build_mounting_point(host)
      MountingPoint.new(self, host)
    end

    def repositories
      {
        site: Repositories::SiteRepository.new(self, adapter),
        content_type: Repositories::ContentTypeRepository.new(self, adapter),
        content_entry: Repositories::ContentEntryRepository.new(self, adapter),
      }
    end

    def adapter
      @options[:adapter] || default_adapter
    end

    def default_adapter
      @default_adapter ||= Locomotive::Models.configuration.default_adapter
    end

  end

end
