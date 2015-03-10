module Mangdown
  # This isn't good, should just have the data in an instance variable
  class MDHash
    attr_reader :properties

		def initialize(options = {})
      @hash = {}
      [:uri, :name].each { |key| @hash[key]  = options.fetch(key) }
      @properties = Properties.new(options[:site] || @hash[:uri])
		end

		# explicit conversion to manga 
    def to_manga
      if @properties.is_manga?(self) || true
        Manga.new(name, uri)
      else
        raise NoMethodError, 'This is not a known manga type'
      end
    end

		# explicit conversion to chapter 
		def to_chapter
      if @properties.is_chapter?(self) || true
        @properties.chapter_klass.new(name, uri)
      else
        raise NoMethodError, 'This is not a known chapter type'
      end
		end

		# explicit conversion to page 
 	  def to_page 
      if @properties.is_page?(self) || true
        Page.new(name, uri)
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

    def [](key)
      @hash[key]
    end

    def inspect
      @hash
    end

    def type
      @properties.type
    end

    def to_hash
      @hash
    end
  end
end

