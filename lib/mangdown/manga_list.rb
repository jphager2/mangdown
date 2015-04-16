module Mangdown

	# a list of manga
  class MangaList

    attr_reader :mangas

    def self.from_data(mangas)
      new(nil, mangas: mangas) 
    end

    def initialize(*uri, mangas: [])
      @mangas = mangas
      if mangas.empty?
        uri.each {|uri| get_mangas(uri)} 
      else
        @mangas.map! { |hash| MDHash.new(hash) }
      end
    end

    def to_yaml
      @mangas.map(&:to_hash).to_yaml
    end

    private
		# get a list of mangas from the uri
    def get_mangas(uri)
			@mangas += Properties.new(uri).manga_list do |uri, name|
				MDHash.new(uri: uri, name: name) 
      end
    end
  end
end
