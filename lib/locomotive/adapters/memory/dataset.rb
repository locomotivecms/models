module Locomotive
  module Adapters
    module Memory

      class Dataset

        class PrimaryKey
          def initialize
            @current = 0
          end

          def increment!
            yield(@current += 1)
            @current
          end
        end

        attr_reader :records, :name

        def initialize(name)
          @name = name
          clear!
        end

        def create(record)
          @primary_key.increment! do |id|
            record[identity] = id
            records[id] = record
          end
        end

        def update(record)
          records[record.id] = records[record.id].deep_merge(record)
        end

        def all
          records.values
        end

        def query
          Query.new(self)
        end

        def clear!
          @records = {}
          @primary_key = PrimaryKey.new
        end
        private

        def identity
          @identity ||= :id
        end

      end
    end
  end
end
