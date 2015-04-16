module Mangdown
  module Adapter
    class Base
      
      attr_reader :root
      def initialize(uri, doc)
        @uri, @doc = uri, doc
        #@root                  = '' 
        #@manga_list_css        = ''
        #@chapter_list_css      = ''
        #@manga_list_uri        = '' 
        #@manga_link_prefix     = '' 
        #@reverse_chapters      = true || false
        #@manga_uri_regex       = /.*/i 
        #@chapter_uri_regex     = /.*/i
        #@page_uri_regex        = /.*/i
      end

      def type
        self.class.to_s.split('::').last.downcase.to_sym
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

      # If no block given, must return an array arrays 
      # [manga_uri, manga_name, adapter_type]
      # If block given, then the block may alter this array
      # Only valid mangas should be returned (using is_manga?(uri))
      def manga_list
        doc.css(@manga_list_css).map { |a| 
          manga = ["#{@manga_link_prefix}#{a[:href]}",a.text.strip,type]
          next(nil) unless is_manga?(manga.first)
          block_given? ? yield(manga) : manga
        }.compact
      end

      # If no block given, must return an array arrays 
      # [chapter_uri, chapter_name, adapter_type]
      # If block given, then the block may alter this array
      # Only valid chapters should be returned (using is_chapter?(uri))
      def manga_chapters
        chapters = doc.css(@chapter_list_css).map { |a|
          chapter = [(root + a[:href].sub(root, '')),a.text.strip,type]
          next(nil) unless is_chapter?(chapter.first)
          block_given? ? yield(chapter) : chapter 
        }.compact
        @reverse_chapters ? chapters.reverse : chapters
      end

      private
      def doc
        @doc ||= Tools.get_doc(@uri)
      end
    end
  end
end
