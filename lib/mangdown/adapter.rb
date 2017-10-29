# frozen_string_literal: true

module Mangdown
  module Adapter
    # Abstract Adapter class
    class Base
      # Returns something truthy if this adapter should be used for the
      # given url or adapter name
      def self.for?(url_or_adapter_name)
        url_or_adapter_name[site.to_s]
      end

      def self.site(site = nil)
        site ? @_site = site : @_site
      end

      attr_reader :uri, :name
      def initialize(uri, doc, name)
        @uri = uri
        @doc = doc
        @name = name
      end

      def site
        self.class.site
      end

      def hydra_opts
        {}
      end

      # Overwrite if you want to check the uri if it belongs to a manga list
      def is_manga_list?(_uri = @uri)
        raise Adapter::NotImplementedError
      end

      # Must return true/false if uri represents a manga for adapter
      def is_manga?(_uri = @uri)
        raise Adapter::NotImplementedError
      end

      # Must return true/false if uri represents a chapter for adapter
      def is_chapter?(_uri = @uri)
        raise Adapter::NotImplementedError
      end

      # Must return true/false if uri represents a page for adapter
      def is_page?(_uri = @uri)
        raise Adapter::NotImplementedError
      end

      # Return Array of Hash with keys: :uri, :name, :site
      def manga_list
        raise Adapter::NotImplementedError
      end

      # Return Hash with keys: :uri, :name, :site
      def manga
        raise Adapter::NotImplementedError
      end

      # Return Array of Hash with keys: :uri, :name, :site
      def chapter_list
        raise Adapter::NotImplementedError
      end

      # Return Hash with keys: :uri, :name, :chapter, :manga, :site
      def chapter
        raise Adapter::NotImplementedError
      end

      # Return Array of Hash with keys: :uri, :name, :site
      def page_list
        raise Adapter::NotImplementedError
      end

      # Return Hash with keys: :uri, :name, :site
      def page
        raise Adapter::NotImplementedError
      end

      def doc
        @doc ||= Tools.get_doc(uri)
      end
    end
  end
end
