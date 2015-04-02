module Mangdown
	class Properties

		attr_reader :info, :type

		def initialize(site)
			@info = Hash.new

      case site.to_s 
      when /mangareader/
        @type = :mangareader
				mangareader
      when /mangapanda/ 
        #mangapanda is a mirror of mangareader
        #that being said, I really don't think this works
        #especially with @info[:root]
        @type = :mangapanda
        mangapanda
      when /mangafox/
        @type = :mangafox
				mangafox
      else
        nil
      end
		end

		def mangareader
			@info[:manga_list_css_klass]  = 'ul.series_alpha li a'
			@info[:manga_css_klass]       = 'div#chapterlist td a'
			@info[:root]                  ||= 'http://www.mangareader.net'
			@info[:manga_link_prefix]     ||= @info[:root] 
			@info[:reverse]               = false
      @info[:manga_uri_regex]       = 
        /#{@info[:root]}(\/\d+)?(\/[^\/]+)(\.html)?/i
      @info[:chapter_uri_regex]     = 
        /#{@info[:root]}(\/[^\/]+){1,2}\/(\d+|chapter-\d+\.html)/i
      @info[:page_uri_regex]        = /.+\.(png|jpg|jpeg)$/i
      @info[:page_image_block]      = ->(doc)   { doc.css('img')[0] }
      @info[:page_image_src_block]  = ->(image) { image[:src] }
      @info[:page_image_name_block] = ->(image) { "#{image[:alt]}.jpg" }
      @info[:build_page_uri_block]  = ->(uri, manga, chapter, num) {
        "#{root}/#{manga.gsub(' ', '-')}/#{chapter}/#{num}"
      }
      @info[:num_pages_block]       = ->(doc) { 
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
			@info[:manga_link_prefix]     = ''
			@info[:reverse]               = true
      @info[:manga_uri_regex]       = 
        /#{@info[:root]}\/manga\/[^\/]+?\//i
      @info[:chapter_uri_regex]     = 
        /#{@info[:manga_uri_regex]}(v\d+\/)?(c\d+\/)(1\.html)/i
      @info[:page_uri_regex]        = /.+\.(png|jpg|jpeg)$/i
      @info[:page_image_block]      = ->(doc)   { doc.css('img')[0] }
      @info[:page_image_src_block]  = ->(image) { image[:src] }
      @info[:page_image_name_block] = ->(image) { 
        image[:alt].sub(/.+\//, '') 
      }
      @info[:build_page_uri_block]  = ->(uri, manga, chapter, num) {
        uri.sub(/\d+\.html/, "#{num}.html")
      }
      @info[:num_pages_block]       = ->(doc) { 
        doc.css('select')[1].css('option').length - 1
      }
		end

    def is_manga?(obj)
      obj.uri.slice(@info[:manga_uri_regex]) == obj.uri
    end

    def is_chapter?(obj)
      obj.uri.slice(@info[:chapter_uri_regex]) == obj.uri
    end

    def is_page?(obj)
      obj.uri.slice(@info[:page_uri_regex]) == obj.uri
    end

    def empty?
      @info.empty?
    end

    def num_pages(doc)
      @info[:num_pages_block].call(doc)
    end

    def page_image(doc)
      @info[:page_image_block].call(doc)
    end

    def page_image_src(doc)
      @info[:page_image_src_block].call(page_image(doc))
    end

    def page_image_name(doc)
      @info[:page_image_name_block].call(page_image(doc))
    end

    def build_page_uri(*args)
      @info[:build_page_uri_block].call(*args)
    end

		private
    def method_missing(method, *args, &block)
      # this should probably be if @info.has_key?(method)
      # or more consisely @info.fetch(method) { super }
      return @info[method] unless @info[method].nil?
      super
    end
	end
end
