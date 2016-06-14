module Mangdown
  module Adapter
    class Base

      # Returns something truthy if this adapter should be used for the 
      # given url or adapter name
      def self.for?(url_or_adapter_name)
        url_or_adapter_name[site.to_s]
      end

      def self.site(site = nil)
        site ? @_site = site : @_site
      end
      
      attr_reader :uri, :doc, :name
      def initialize(uri, doc, name)
        @uri = uri
        @doc = doc
        @name = name
      end

      def site
        self.class.site
      end

      # Overwrite if you want to check the uri if it belongs to a manga list
      def is_manga_list?(uri = @uri)
        raise NotImplementedError
      end

      # Must return true/false if uri represents a manga for adapter
      def is_manga?(uri = @uri)
        raise NotImplementedError
      end

      # Must return true/false if uri represents a chapter for adapter
      def is_chapter?(uri = @uri)
        raise NotImplementedError
      end

      # Must return true/false if uri represents a page for adapter
      def is_page?(uri = @uri)
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

      # Return Hash with keys: :uri, :name, :site
      def page
        raise NotImplementedError
      end

      private
      def doc
        @doc ||= Tools.get_doc(uri)
      end
    end
  end
end
