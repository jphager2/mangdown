module Mangdown
	class Properties

		def initialize(uri, site = nil, doc = nil)
      case (site || uri).to_s
      when /mangareader/
				@adapter = Mangareader.new(uri, doc)
      when /mangapanda/ 
				@adapter = Mangapanda.new(uri, doc)
      when /mangafox/
				@adapter = Mangafox.new(uri, doc)
      when /wiemanga/
				@adapter = Wiemanga.new(uri, doc)
      else
        raise ArgumentError, 
          "Bad Site: No Properties Specified for Site <#{uri}>"
      end
		end

    private
    def method_missing(method, *args, &block)
      if @adapter.respond_to?(method)
        @adapter.__send__(method, *args, &block)
      else
        super
      end
    end
	end

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
          manga = ["#{@manga_link_prefix}#{a[:href]}", a.text, type]
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
          chapter = [(root + a[:href].sub(root, '')), a.text, type]
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

  class Mangareader < Adapter::Base
    def initialize(uri, doc)
      super
			@root                  ||= 'http://www.mangareader.net'
			@manga_list_css        = 'ul.series_alpha li a'
			@chapter_list_css      = 'div#chapterlist td a'
      @manga_list_uri        = "#{@root}/alphabetical"
			@manga_link_prefix     = @root 
			@reverse_chapters      = false
      @manga_uri_regex       = 
        /#{@root}(\/\d+)?(\/[^\/]+)(\.html)?/i
      @chapter_uri_regex     = 
        /#{@root}(\/[^\/]+){1,2}\/(\d+|chapter-\d+\.html)/i
      @page_uri_regex        = /.+\.(png|jpg|jpeg)$/i
    end

    def build_page_uri(uri, manga, chapter, page_num)
      "#{root}/#{manga.gsub(' ', '-')}/#{chapter}/#{page_num}"
    end

    def num_pages
      doc.css('select')[1].css('option').length
    end

    def page_image_src
      page_image[:src]
    end

    def page_image_name
      "#{page_image[:alt]}.jpg"
    end

    private
    def page_image
      doc.css('img')[0]
    end
  end

  class Mangapanda < Mangareader
    def initialize(uri, doc)
      @root = 'http://www.mangapanda.com'
      super
    end
  end

  class Mangafox < Adapter::Base
    def initialize(uri, doc)
      super
			@manga_list_css        = 'div.manga_list li a'
			@chapter_list_css      = 'a.tips'
			@root                  = 'http://mangafox.me'
      @manga_list_uri        = "#{@root}/manga"
			@manga_link_prefix     = ''
			@reverse_chapters      = true
      @manga_uri_regex       = 
        /#{@root}\/manga\/[^\/]+?\//i
      @chapter_uri_regex     = 
        /#{@manga_uri_regex}(v\d+\/)?(c\d+\/)(1\.html)/i
      @page_uri_regex        = /.+\.(png|jpg|jpeg)$/i
		end

    def build_page_uri(uri, manga, chapter, page_num)
      uri.sub(/\d+\.html/, "#{page_num}.html")
    end

    def num_pages
      doc.css('select')[1].css('option').length - 1
    end

    def page_image_src
      page_image[:src]
    end

    def page_image_name
      page_image[:alt].sub(/.+\//, '') 
    end

    private
    def page_image
      doc.css('img')[0]
    end
  end

  class Wiemanga < Adapter::Base
    def initialize(uri, doc)
      super
			@root                  = 'http://www.wiemanga.com'
      @manga_list_uri        = 
        "#{@root}/search/?name_sel=contain&author_sel=contain" +
        "&completed_series=either"
			@manga_list_css        = 'a.resultbookname'
			@chapter_list_css      = 
        '.chapterlist tr:not(:first-child) .col1 a'
			@manga_link_prefix     = '' 
			@reverse_chapters      = true
      @manga_uri_regex       = /#{@root}\/manga\/([^\/]+)(\.html)?/i
      @chapter_uri_regex     = 
        /#{@root}\/chapter\/([^\/]+)\/(\d+)(\/|\.html)?/i
      @page_uri_regex        = /.+\.(png|jpg|jpeg)$/i
		end

    def build_page_uri(uri, manga, chapter, page_num)
      "#{uri}-#{page_num}.html"
    end

    def num_pages
      doc.css('select#page')[1].css('option').length
    end

    def page_image_src
      page_image[:src]
    end

    def page_image_name
      page_image[:src].sub(/.+\//, '') 
    end

    private
    def page_image
      doc.css('img#comicpic')[0]
    end
  end
end

