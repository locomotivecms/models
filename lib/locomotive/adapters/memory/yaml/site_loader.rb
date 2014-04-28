require 'yaml'

module Locomotive
  module Adapters
    module Memory
      module Yaml

        class SiteLoader

          def initialize(path)
            @root_path  = path
            @path       = File.join(@root_path, 'config', 'site.yml')
          end

          def all
            attributes = load_attributes
            (attributes['domains'] ||= []) << '0.0.0.0'
            [attributes]
          end

          alias :to_a :all

          private

          def load_attributes
            if File.exists?(@path)
              file = File.read(@path).force_encoding('utf-8')
              YAML::load(file)
            else
              raise 'config/site.yml was not found'
            end
          end

        end

      end
    end
  end
end