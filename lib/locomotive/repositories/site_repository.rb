module Locomotive
  module Repositories

    class SiteRepository < Repository

      def find_by_host(host)
        query do
          where('domains.in' => host)
        end.first
      end
    end
  end
end
