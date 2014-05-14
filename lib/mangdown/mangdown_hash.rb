module Mangdown
  class MDHash < ::Hash

		def initialize(options = {})
			self[:uri]     = options[:uri]
			self[:name]    = options[:name]
		end

		# explicit conversion to manga 
    def to_manga
      Manga.new(self[:name], self[:uri])
    end

		# explicit conversion to chapter 
		def to_chapter
			klass = Properties.new(self[:uri]).chapter_klass
		  klass.new(self[:name], self[:uri])
		end

		# explicit conversion to page 
 	  def to_page 
		  Page.new(self[:name], self[:uri])
		end	
  end
end

