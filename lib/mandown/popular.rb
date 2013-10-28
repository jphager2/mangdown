module Mandown
  class PopularManga
		attr_reader :uri, :mangas_list, :mangas

		def initialize(uri, num_mangas)
			@uri = uri #uri = 'http://www.mangareader.net/popular/'
		  @num_mangas = num_mangas
			@mangas_list = []
			@mangas = []

			@root = 'http://www.mangareader.net'

			get_mangas_list
		end

		def get_manga(index)
      uri, name = @mangas_list[index - 1]
			unless @mangas.find {|manga| (manga.name == name) or (manga.uri == uri)}
        @mangas << Manga.new( uri, name )
		  else
				nil
		  end
		end

		def get_mangas_list
      (@num_mangas / 30.0).ceil.times do |time|
        get_pop_page_manga(time).each { |manga| @mangas_list << manga }
			end
			@doc = "Nokogiri::HTML::Document"
		end

		def get_doc(uri)
      @doc = Nokogiri::HTML(open(uri))
		end
		
		def get_pop_page_manga(time)
			num = 30 * (time - 1)
			page = @uri + '/' + num.to_s
			get_doc(page)
      
			last = (@num_mangas > 30) ? 30 : @num_mangas
			@num_mangas -= 30

			get_manga_on_page[0..(last - 1)]
		end

		def get_manga_on_page
      @doc.css('h3 a').map {|a| [@root + a['href'], a.text]}
		end
	end
end
