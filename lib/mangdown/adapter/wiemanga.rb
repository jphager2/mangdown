module Mangdown
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
