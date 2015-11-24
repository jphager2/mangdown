module Mangdown
  class Mangareader < Adapter::Base
    Mangdown::ADAPTERS << self

    def initialize(uri, doc)
      super
			@root                  ||= 'http://www.mangareader.net'
			@manga_list_css        = 'ul.series_alpha li a'
      @manga_name_css        = 'h2.aname'
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

    def manga_name
      CGI.unescapeHTML(super)
    end

    def build_page_uri(uri, manga, chapter, page_num)
      slug = slug(manga)
      "#{root}/#{slug}/#{chapter}/#{page_num}"
    end

    def num_pages
      doc.css('select')[1].css('option').length
    end

    def page_image_src
      page_image[:src]
    end

    def page_image_name
      page_image[:alt].sub(/([^\d]*)(\d+)(\.\w+)?$/) { 
        "#{Regexp.last_match[1]}" +
        "#{Regexp.last_match[2].to_s.rjust(3, '0')}"
      }
    end

    private
    def page_image
      doc.css('img')[0]
    end

    def slug(string)
      string.gsub(' ', '-').gsub(/:/, '')
    end
  end
end

