module Locomotive
  module Adapters
    module Memory
      class Mapper < Locomotive::Adapters::AbstractMapper

        def self.from_record record
          new(record.compact)
        end

        def to_record
          self.attributes
        end
      end
    end
  end
end