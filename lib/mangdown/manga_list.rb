module Mangdown
  class MangaList
    include Enumerable

    def self.from_data(manga)
      new(manga) 
    end

    attr_reader :manga

    alias to_a manga
    alias to_ary manga

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

      manga = adapter.manga_list.map { |manga| MDHash.new(manga) }
      
      merge(manga)
    end

    def merge(other)
      @manga += other.to_ary

      return self
    end
  end
end
