module Mangdown
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
end
