module Mangdown
  module Adapter
    class Base
      
      attr_reader :root
      def initialize(uri, doc, name)
        @uri, @doc, @name = uri, doc, name
        #@root                    = '' 
        #@manga_list_css          = ''
        #@chapter_list_css        = ''
        #@manga_name_css          = ''
        #@chapter_name_css        = ''
        #@chapter_manga_name_css  = ''
        #@chapter_number_css        = ''
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

      # Override this if you want to use an adapter name for a site that is 
      # not matched in the site's url
      # e.g. CoolAdapterName < Adapter::Base
      # def site
      #   "mangareader"
      # end
      def self.site
        type.to_s
      end

      def site
        self.class.site
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

      # If no block given, must return an array arrays 
      # [manga_uri, manga_name, adapter_type]
      # If block given, then the block may alter this array
      # Only valid mangas should be returned (using is_manga?(uri))
      def collect_manga_list
        doc.css(@manga_list_css).map { |a| 
          manga = ["#{@manga_link_prefix}#{a[:href]}", a.text.strip, type]
          if is_manga?(manga.first)
            block_given? ? yield(manga) : manga
          end
        }.compact
      end

      # If no block given, must return an array arrays 
      # [chapter_uri, chapter_name, adapter_type]
      # If block given, then the block may alter this array
      # Only valid chapters should be returned (using is_chapter?(uri))
      def manga_chapters
        chapters = doc.css(@chapter_list_css).map { |a|
          link = root + a[:href].sub(root, '')
          chapter = [link, a.text.strip, type]
          if is_chapter?(chapter.first)
            block_given? ? yield(chapter) : chapter 
          end
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
