module Mangdown
  class MangaList
    include Enumerable

    def self.from_data(manga)
      new(manga) 
    end

    attr_reader :manga

    def initialize(manga = [])
      @manga = manga.map! { |hash| MDHash.new(hash) }
    end

    def each(&block)
      manga.each(&block)
    end 

    def to_yaml
      @manga.map(&:to_hash).to_yaml
    end

    def load_manga(uri)
      adapter = Mangdown.adapter!(uri)

      manga = adapter.collect_manga_list { |uri, name, site| 
        MDHash.new(uri: uri, name: name, site: site) }
      
      merge(manga)
    end

    def to_a
      manga
    end

    def merge(other)
      @manga += other.to_a

      return self
    end
  end
end
