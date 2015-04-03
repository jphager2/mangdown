module Mangdown
	class Properties

		attr_reader :info, :type

		def initialize(uri, site = nil, doc = nil)
			@info  = Hash.new
      @uri   = uri
      @doc   = doc
      site ||= uri

      case site.to_s 
      when /mangareader/
        @type = :mangareader
				mangareader
      when /mangapanda/ 
        @type = :mangapanda
        mangapanda
      when /mangafox/
        @type = :mangafox
				mangafox
      when /wiemanga/
        @type = :wiemanga
				wiemanga
      else
        raise ArgumentError, 
          "Bad Site: No Properties Specified for Site <#{site}>"
      end
		end

		def mangareader
			@info[:manga_list_css_klass]  = 'ul.series_alpha li a'
			@info[:manga_css_klass]       = 'div#chapterlist td a'
			@info[:root]                  ||= 'http://www.mangareader.net'
      @info[:manga_list_uri]        = "#{@info[:root]}/alphabetical"
			@info[:manga_link_prefix]     ||= @info[:root] 
			@info[:reverse]               = false
      @info[:manga_uri_regex]       = 
        /#{@info[:root]}(\/\d+)?(\/[^\/]+)(\.html)?/i
      @info[:chapter_uri_regex]     = 
        /#{@info[:root]}(\/[^\/]+){1,2}\/(\d+|chapter-\d+\.html)/i
      @info[:page_uri_regex]        = /.+\.(png|jpg|jpeg)$/i
      @info[:page_image_block]      = -> { doc.css('img')[0] }
      @info[:page_image_src_block]  = -> { page_image[:src] }
      @info[:page_image_name_block] = -> { "#{page_image[:alt]}.jpg" }
      @info[:build_page_uri_block]  = ->(uri, manga, chapter, num) {
        "#{root}/#{manga.gsub(' ', '-')}/#{chapter}/#{num}"
      }
      @info[:num_pages_block]       = -> { 
        doc.css('select')[1].css('option').length
      }
		end

    def mangapanda
      @info[:root]                 = 'http://www.mangapanda.com'
			@info[:manga_link_prefix]    = @info[:root] 
      mangareader
    end

		def mangafox
			@info[:manga_list_css_klass]  = 'div.manga_list li a'
			@info[:manga_css_klass]       = 'a.tips'
			@info[:root]                  = 'http://mangafox.me'
      @info[:manga_list_uri]        = "#{@info[:root]}/manga"
			@info[:manga_link_prefix]     = ''
			@info[:reverse]               = true
      @info[:manga_uri_regex]       = 
        /#{@info[:root]}\/manga\/[^\/]+?\//i
      @info[:chapter_uri_regex]     = 
        /#{@info[:manga_uri_regex]}(v\d+\/)?(c\d+\/)(1\.html)/i
      @info[:page_uri_regex]        = /.+\.(png|jpg|jpeg)$/i
      @info[:page_image_block]      = -> { doc.css('img')[0] }
      @info[:page_image_src_block]  = -> { page_image[:src] }
      @info[:page_image_name_block] = -> { 
        page_image[:alt].sub(/.+\//, '') 
      }
      @info[:build_page_uri_block]  = ->(uri, manga, chapter, num) {
        uri.sub(/\d+\.html/, "#{num}.html")
      }
      @info[:num_pages_block]       = -> { 
        doc.css('select')[1].css('option').length - 1
      }
		end

		def wiemanga
			@info[:root]                  ||= 'http://www.wiemanga.com'
      @info[:manga_list_uri]        = 
        "#{@info[:root]}/search/?name_sel=contain&author_sel=contain" +
        "&completed_series=either"
			@info[:manga_list_css_klass]  = 'a.resultbookname'
			@info[:manga_css_klass]       = 
        '.chapterlist tr:not(:first-child) .col1 a'
			@info[:manga_link_prefix]     ||= '' 
			@info[:reverse]               = true
      @info[:manga_uri_regex]       = 
        /#{@info[:root]}\/manga\/([^\/]+)(\.html)?/i
      @info[:chapter_uri_regex]     = 
        /#{@info[:root]}\/chapter\/([^\/]+)\/(\d+)(\/|\.html)?/i
      @info[:page_uri_regex]        = /.+\.(png|jpg|jpeg)$/i
      @info[:page_image_block]      = -> { doc.css('img#comicpic')[0] }
      @info[:page_image_src_block]  = -> { page_image[:src] }
      @info[:page_image_name_block] = -> { 
        page_image[:src].sub(/.+\//, '') 
      }
      @info[:build_page_uri_block]  = ->(uri, manga, chapter, num) {
        "#{uri}-#{num}.html"
      }
      @info[:num_pages_block]       = -> { 
        doc.css('select#page')[1].css('option').length
      }
		end

    def is_manga?(uri = @uri)
      uri.slice(@info[:manga_uri_regex]) == uri
    end

    def is_chapter?(uri = @uri)
      uri.slice(@info[:chapter_uri_regex]) == uri
    end

    def is_page?(uri = @uri)
      uri.slice(@info[:page_uri_regex]) == uri
    end

    def num_pages
      @info[:num_pages_block].call
    end

    def page_image
      @info[:page_image_block].call
    end

    def page_image_src
      @info[:page_image_src_block].call
    end

    def page_image_name
      @info[:page_image_name_block].call
    end

    def build_page_uri(*args)
      @info[:build_page_uri_block].call(*args)
    end

    def manga_list
      doc.css(@info[:manga_list_css_klass]).map { |a| 
        manga = ["#{@info[:manga_link_prefix]}#{a[:href]}", a.text]
        block_given? ? yield(manga) : manga
      }
    end

    def manga_chapters
      chapters = doc.css(@info[:manga_css_klass]).map { |a|
        chapter = [(root + a[:href].sub(root, '')), a.text, type]
        next(nil) unless is_chapter?(chapter.first)
        block_given? ? yield(chapter) : chapter 
      }.compact
      reverse? ? chapters.reverse : chapters
    end

    def reverse?
      !!@info[:reverse]
    end

    def root
      @info[:root]
    end

		private
    def doc
      @doc ||= Tools.get_doc(@uri)
    end
	end
end
