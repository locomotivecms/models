module Locomotive
  module Repositories

    class SiteRepository < Repository

      def find_by_host(host)
        query do
          where('domains.in' => host)
        end.first
      end

      def load
        [].tap do |data|
          all.each do |site|
            data << Locomotive::Entities::Site.new(site)
          end
        end
      end
    end

  end
end
