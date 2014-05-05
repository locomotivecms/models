module Locomotive

  class MountingPoint

    attr_reader :datastore
    attr_reader :host

    def initialize(datastore, host)
      @datastore  = datastore
      @host       = host
    end

    def assets_path
      raise 'hmmmm, do not know how to get it (get it from the site?)'
    end

    def site
      @site ||= repository(:site).find_by_host(host)
    end

    def content_types
      @content_types ||= repository(:content_types).find_by_site(site)
    end

    protected

    def repository(collection_name)
      datastore.repositories[collection_name.to_sym]
    end

  end

end