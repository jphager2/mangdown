module Mangdown
  class MDHash
    include Equality

    def initialize(options = {})
      uri = options.fetch(:uri)
      name = options[:name]
      site = options[:site]
      @properties = Properties.new(uri, site, nil, name)

      @hash = {}
      @hash[:name] = name
      @hash[:uri] = Mangdown::Uri.new(uri)
      @hash[:site] = @properties.type
      @hash[:manga] = options[:manga]
      @hash[:chapter] = options[:chapter]
    end

    # explicit conversion to manga 
    def to_manga
      if @properties.is_manga?
        Manga.new(uri, name)
      else
        raise NoMethodError, 'This is not a known manga type'
      end
    end

    # explicit conversion to chapter 
    def to_chapter
      if @properties.is_chapter?
        Chapter.new(uri, name, manga)
      else
        raise NoMethodError, 'This is not a known chapter type'
      end
    end

    # explicit conversion to page 
    def to_page 
      if @properties.is_page?
        Page.new(uri, name, chapter)
      else
        raise NoMethodError, 'This is not a known page type'
      end
    end 

    # name reader
    def name
      @hash[:name]
    end

    # uri reader
    def uri
      @hash[:uri]
    end

    def manga
      @hash[:manga]
    end

    def chapter
      @hash[:chapter ]
    end

    # name writer
    def name=(other)
      @hash[:name] = other
    end

    # uri writer
    def uri=(other)
      @hash[:uri] = other
    end

    def manga=(other)
      @hash[:manga] = other
    end
    
    def chapter=(other)
      @hash[:chapter] = other
    end

    def [](key)
      @hash[key]
    end

    def to_hash
      @hash
    end

    def inspect
      to_hash.to_s
    end
    alias_method :to_s, :inspect

    def type
      @properties.type
    end
  end
end
