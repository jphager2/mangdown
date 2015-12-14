module Mangdown

  # a list of manga
  class MangaList

    def self.from_data(mangas)
      new(nil, mangas: mangas) 
    end

    attr_reader :mangas

    def initialize(*uris, mangas: [])
      @mangas = mangas.map! { |hash| MDHash.new(hash) }
      if uris.any?
        uris.each { |uri| get_mangas(uri) } 
      end
    end

    def to_yaml
      @mangas.map(&:to_hash).to_yaml
    end

    private
    # get a list of mangas from the uri
    def get_mangas(uri)
      
      @mangas += Properties.new(uri).collect_manga_list { |uri, name, site| 
        MDHash.new(uri: uri, name: name, site: site) 
      }
    end
  end
end
