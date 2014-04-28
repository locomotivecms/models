require_relative 'yaml/site_loader'

module Locomotive
  module Adapters
    module Memory

      class YamlLoader

        def initialize(path)
          @path         = path
          @sub_loaders  = {}
        end

        def get(name)
          @sub_loaders[name] ||= case name
          when :site then Yaml::SiteLoader.new(@path)
          else
            raise 'Not implemented'
          end
        end

      end

    end
  end
end