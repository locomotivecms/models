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

        def insert(record)
          @primary_key.increment! do |id|
            record[identity] = id
            records[id] = record
          end
        end

        def update(record)
          records[record[identity]] = records[record[identity]].deep_merge(record)
        end

        def delete(id)
          records.delete(id)
        end

        def size
          records.size
        end

        def all
          records.values
        end

        def find id, locale
          records.fetch(id) do
            raise Locomotive::Repository::RecordNotFound, "could not find #{name} with #{identity} = #{id}"
          end
        end

        def exists? id
          !!id && records.has_key?(id)
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
