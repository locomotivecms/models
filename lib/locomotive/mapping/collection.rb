module Locomotive
  module Mapping
    class Collection

      attr_accessor :collection

      def initialize collection
        self.collection = collection
      end

      # def serialize(entity)
      #   entity.to_record
      # end

      def deserialize(records)
        [].tap do |data|
          records.each do |record|
            data << eval("Locomotive::Entities::#{constantize(collection)}").new(record)
          end
        end
      end

      private

      def constantize name
        name[0].upcase +  name[1..name.length]
      end

    end
  end
end
