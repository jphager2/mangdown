module Mangdown
  class MDHash
    include Equality

    attr_reader :properties

		def initialize(options = {})
      @properties = Properties.new(options[:site] || options[:uri])

      @hash = {}
      [:uri, :name].each {|key| @hash[key] = options.fetch(key)}
      @hash[:uri]  = Mangdown::Uri.new(@hash[:uri])
      @hash[:site] = @properties.type
		end

		# explicit conversion to manga 
    def to_manga
      if @properties.is_manga?(self)
        Manga.new(name, uri)
      else
        raise NoMethodError, 'This is not a known manga type'
      end
    end

		# explicit conversion to chapter 
		def to_chapter
      if @properties.is_chapter?(self)
        @properties.chapter_klass.new(name, uri)
      else
        raise NoMethodError, 'This is not a known chapter type'
      end
		end

		# explicit conversion to page 
 	  def to_page 
      if @properties.is_page?(self)
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
    alias_method :to_hash, :inspect

    def type
      @properties.type
    end
  end
end

