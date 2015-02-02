module Mangdown
  class MDHash < ::Hash

		def initialize(options = {})
			self[:uri]  = options[:uri]
			self[:name] = options[:name]
		end

		# explicit conversion to manga 
    def to_manga
      Manga.new(name, uri)
    end

		# explicit conversion to chapter 
		def to_chapter
			Properties.new(uri).chapter_klass.new(name, uri)
		end

		# explicit conversion to page 
 	  def to_page 
		  Page.new(name, uri)
		end	

    # name reader
    def name
      self[:name]
    end

    # uri reader
    def uri
      self[:uri]
    end
  end
end

