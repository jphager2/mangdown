module Mandown
  class Manga
    attr_reader :chapters, :chapters_list, :name, :url
    def initialize(uri, name)
      @uri = uri
      @name = name
      @chapters = []
      @chapters_list = []
      @doc = get_doc(@uri)
      @root = 'http://www.mangareader.net'
      get_chapters_list
    end

    def get_chapters_list
      @doc.css('div#chapterlist td a').each do |chapter|
        @chapters_list << ([@root + chapter['href'], chapter.text])
      end
    end
    
    def get_doc(uri)
      @doc = Nokogiri::HTML(open(uri))
    end

		def get_chapter(number)
			uri, name = @chapters_list[number - 1]
			@chapters << Chapter.new(uri, name)
		end
  end
end
