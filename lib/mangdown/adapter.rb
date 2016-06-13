module Mangdown
  module Adapter
    class Base

      # public api
      #
      # :is_manga_list?, :is_manga?, :is_chapter?, :is_page?, :manga, 
      # :chapter, :site, :manga_list, :chapter_list, :page_list, 
      # :page_image_src, :page_image_name

      # Returns something truthy if this adapter should be used for the 
      # given url or adapter name
      def self.for?(url_or_adapter_name)
        url_or_adapter_name[site.to_s]
      end

      def self.site(site = nil)
        site ? @_site = site : @_site
      end
      
      attr_reader :root
      def initialize(uri, doc, name)
        @uri = uri
        @doc = doc
        @name = name
        @root = nil
      end

      def site
        self.class.site
      end

      # Overwrite if you want to check the uri if it belongs to a manga list
      def is_manga_list?(uri)
        raise NotImplementedError
      end

      # Must return true/false if uri represents a manga for adapter
      def is_manga?(uri = nil)
        raise NotImplementedError
      end

      # Must return true/false if uri represents a chapter for adapter
      def is_chapter?(uri = nil)
        raise NotImplementedError
      end

      # Must return true/false if uri represents a page for adapter
      def is_page?(uri = nil)
        raise NotImplementedError
      end

      # Must return the src for the page image
      def page_image_src
        raise NotImplementedError
      end

      # Must return the name of the page image
      def page_image_name
        raise NotImplementedError
      end

      # Return Array of Hash with keys: :uri, :name, :site
      def manga_list
        raise NotImplementedError
      end

      # Return Hash with keys: :uri, :name, :site
      def manga
        raise NotImplementedError
      end

      # Return Array of Hash with keys: :uri, :name, :site
      def chapter_list
        raise NotImplementedError
      end

      # Return Hash with keys: :uri, :name, :chapter, :manga, :site
      def chapter
        raise NotImplementedError
      end

      # Return Array of Hash with keys: :uri, :name, :site
      def page_list
        raise NotImplementedError
      end

      private
      def doc
        @doc ||= Tools.get_doc(@uri)
      end
    end
  end
end
