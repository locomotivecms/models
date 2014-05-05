require_relative '../entity'

module Locomotive
  module Entities
    class ContentAsset < Entity

      ## fields ##
      field :source

      ## other accessors ##
      attr_accessor :folder, :filepath, :uri

      ## methods ##

      # Name of the file
      #
      # @return [ String ] Name of the file
      #
      def filename
        return @filename if @filename

        if self.uri
          @filename = File.basename(self.uri.path)
        else
          @filename = File.basename(self.filepath)
        end
      end

      # Content of the asset.
      #
      # @return [ String ] The content of the asset
      #
      def content
        return @raw if @raw

        if self.uri
          @raw = HTTParty.get(self.uri.to_s).body
        else
          @raw = File.read(self.filepath)
        end
      end

      def size
        if self.uri
          self.content.size
        else
          File.size(self.filepath)
        end
      end

      # Return true if the uri or the file exists.
      #
      # @return [ Boolean ] True if it exists
      #
      def exists?
        self.size
        true
      rescue
        false
      end

      def local_filepath
        File.join('/', self.folder, self.filename)
      end

      # Return the params used for the API.
      #
      # @return [ Hash ] The params
      #
      def to_params
        return {} if self.uri

        { source: File.new(self.filepath) }
      end

      def to_s
        self.uri ? self.uri.path : self.filename
      end

    end
  end
end
