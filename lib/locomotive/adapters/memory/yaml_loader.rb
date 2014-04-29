Dir[File.dirname(__FILE__) + '/yaml/*.rb'].each {|file| require file }

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
          when :content_types then Yaml::ContentTypesLoader.new(@path)
          else
            raise 'Not implemented'
          end
        end

      end

    end
  end
end