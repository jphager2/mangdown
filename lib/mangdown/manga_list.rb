module Mangdown

	# a list of manga
  class MangaList

    attr_reader :mangas

    def initialize(*uri)
      @mangas = []

      uri.each {|uri| get_mangas(uri)}
    end

		# get a list of mangas from the uri
    def get_mangas(uri)
			properties = Properties.new(uri)
      doc        = Tools.get_doc(uri)
      
      # This should be put in a tool
			doc.css(properties.manga_list_css_klass).each do |a|
				@mangas << MDHash.new( 
					uri: "#{properties.manga_link_prefix}#{a[:href]}", 
					name: a.text
			  )
      end
    end
  end
end
