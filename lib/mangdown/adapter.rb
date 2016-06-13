module Mangdown
  module Adapter
    class Base

      # Returns something truthy if this adapter should be used for the 
      # given url or adapter name
      def self.for?(url_or_adapter_name)
        url_or_adapter_name[site]
      end
      
      attr_reader :root
      def initialize(uri, doc, name)
        @uri, @doc, @name = uri, doc, name
        #@root                    = '' 
        #@manga_list_css          = ''
        #@chapter_list_css        = ''
        #@manga_name_css          = ''
        #@chapter_name_css        = ''
        #@chapter_manga_name_css  = ''
        #@chapter_number_css      = ''
        #@manga_list_uri          = '' 
        #@manga_link_prefix       = '' 
        #@reverse_chapters        = true || false
        #@manga_uri_regex         = /.*/i 
        #@chapter_uri_regex       = /.*/i
        #@page_uri_regex          = /.*/i
      end

      def self.type
        name.split('::').last.downcase.to_sym
      end

      def type
        self.class.type
      end

      def self.site
        type.to_s
      end

      def site
        self.class.site
      end

      # Overwrite if you want to check the uri if it belongs to a manga list
      def is_manga_list?(uri = @uri)
        true
      end

      # Must return true/false if uri represents a manga for adapter
      def is_manga?(uri = @uri)
        uri.slice(@manga_uri_regex) == uri
      end

      # Must return true/false if uri represents a chapter for adapter
      def is_chapter?(uri = @uri)
        uri.slice(@chapter_uri_regex) == uri
      end

      # Must return true/false if uri represents a page for adapter
      def is_page?(uri = @uri)
        uri.slice(@page_uri_regex) == uri
      end

      # Must return a string
      def manga_name
        if is_manga?
          doc.css(@manga_name_css).text
        elsif is_chapter?
          chapter_manga_name
        end
      end

      def chapter_name
        if @name
          @name.sub(/\s(\d+)$/) { |num| ' ' + num.to_i.to_s.rjust(5, '0') }
        else
          doc.css(@chapter_name_css).text
        end
      end

      def chapter_manga_name
        if @name
          @name.slice(/(^.+)\s/, 1) 
        else
          doc.css(@chapter_manga_name_css).text
        end
      end

      def chapter_number
        raise NoMethodError, "Not a chapter" unless is_chapter?

        if @name
          @name.slice(/\d+\z/).to_i 
        else
          doc.css(@chapter_number_css).text
        end
      end

      # Must return a uri for a page given the arguments
      def build_page_uri(uri, manga, chapter, page_num)
      end

      # Must return the number of pages for a chapter 
      def num_pages
      end

      # Must return the src for the page image
      def page_image_src
      end

      # Must return the name of the page image
      def page_image_name
      end

      # Only valid mangas should be returned (using is_manga?(uri))
      def manga_list
        doc.css(@manga_list_css).map { |a| 
          uri = "#{@manga_link_prefix}#{a[:href]}"
          manga = { uri: uri, name: a.text.strip, site: site }

          manga if is_manga?(manga[:uri])
        }.compact
      end

      def manga
        { uri: @uri, name: manga_name, site: site }
      end

      # Only valid chapters should be returned (using is_chapter?(uri))
      def chapter_list
        chapters = doc.css(@chapter_list_css).map { |a|
          uri = root + a[:href].sub(root, '')
          chapter = { uri: uri, name: a.text.strip, site: type }

          chapter if is_chapter?(chapter[:uri])
        }.compact
        @reverse_chapters ? chapters.reverse : chapters
      end

      def chapter
        { uri: @uri, 
          manga: manga_name, 
          name: chapter_name,
          chapter: chapter_number,
          site: site }
      end

      private
      def doc
        @doc ||= Tools.get_doc(@uri)
      end
    end
  end
end
