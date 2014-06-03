module Locomotive
  module Repositories

    class ContentTypesRepository
      include Repository

      def find_by_name(name)
        query do
          where('name.matches' => name)
        end.first
      end
    end
  end
end