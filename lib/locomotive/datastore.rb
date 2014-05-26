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
      }
    end

    def adapter
      @options[:adapter] || default_adapter
    end

    def default_adapter
      @default_adapter ||= Adapters::MemoryAdapter.new(mapper)
    end

    def mapper
      @options[:mapper] || default_mapper
    end

    def default_mapper
      @default_mapper ||= Locomotive::Mapper.load!(File.expand_path('../models/cms_mapper.rb', __FILE__))
    end
  end

end
