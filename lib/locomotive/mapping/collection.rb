module Locomotive
  module Mapping
    class Collection

      attr_accessor :entity

      def initialize name
        self.entity = eval("Locomotive::Entities::#{constantize(name)}")
      end

      def serialize(record)
        record.to_record
      end

      def deserialize(records)
        records.map do |record|
          entity.from_record(record)
        end
      end

      private

      def constantize name
        { site: 'Site',
          content_type: 'ContentType',
          content_entry: 'ContentEntry'
        }[name]
      end

    end
  end
end
