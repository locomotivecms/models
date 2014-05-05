require 'yaml'

module Locomotive
  module Adapters
    module Memory
      module Yaml

        class ContentTypesLoader

          def initialize(path)
            @root_path  = path
            @path       = File.join(@root_path, 'app', 'content_types')
          end

          def all
            []
          end

          alias :to_a :all

          private

          def load_attributes
            raise 'TODO'
          end

        end

      end
    end
  end
end
