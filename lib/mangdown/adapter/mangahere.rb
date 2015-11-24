module Mangdown
  class Mangahere < Adapter::Base
    Mangdown::ADAPTERS << self

    def initialize(uri, doc, name)
      super
			@root                  = 'http://www.mangahere.co'
			@manga_list_css        = 'a.manga_info'
      @manga_name_css        = 'h1.title'
			@chapter_list_css      = '.detail_list ul a'
      @manga_list_uri        = "#{@root}/mangalist/"
			@manga_link_prefix     = ''
			@reverse_chapters      = true
      @manga_uri_regex       = 
        /#{@root}\/manga\/([^\/]+\/)?/i
      @chapter_uri_regex     = 
        /#{@manga_uri_regex}(v\d+\/)?(c\d+\/)(1\.html)?/i
      @page_uri_regex        = /.+\.(png|jpg|jpeg)$/i
		end

    def manga_name
      CGI.unescapeHTML(super.downcase).upcase
    end

    def build_page_uri(uri, manga, chapter, page_num)
      if page_num == 1
        uri
      else
        uri.sub(/\/[^\/]*$/, "/#{page_num}.html")
      end
    end

    def num_pages
      doc.css('.go_page span.right select')[0].css('option').length
    end

    def page_image_src
      page_image[:src].sub(/\?.*$/, '')
    end

    def page_image_name
      doc.css('.go_page span.right select')[0].css('option[selected]')
        .text.rjust(3, '0')
    end

    private
    def page_image
      doc.css('.read_img img')[0]
    end
  end
end
