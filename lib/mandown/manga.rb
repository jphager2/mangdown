module Mandown
  class Manga
    include ::Mandown::Tools

    attr_reader :chapters, :chapters_list, :name, :uri

    def initialize(uri, name)
      @uri = uri
      @name = name
      @chapters = []
      @chapters_list = []
      @doc = get_doc(@uri)
      @root = get_root(@uri) 

      get_chapters_list
    end

    def get_chapters_list
      @doc.css('div#chapterlist td a').each do |chapter|
        @chapters_list << ([@root + chapter['href'], chapter.text])
      end

      @doc = "Nokogiri::HTML::Document"
    end
    
		def get_chapter(number)
			uri, name = @chapters_list[number - 1]
			@chapters << Chapter.new(uri, name)
		end
  end
end
