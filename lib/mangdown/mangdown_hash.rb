module Mangdown
  class MDHash < ::Hash

		def initialize(options = {})
			self[:uri]  = options[:uri]
			self[:name] = options[:name]
		end

		# get a manga object
    def get_manga
      Manga.new(self[:name], self[:uri])
    end

		# get a chapter object
		def get_chapter(type)
		  type.new(self[:name], self[:uri])
		end

		# get a page object
	  def get_page 
		  Page.new(self[:name], self[:uri])
		end	
  end
end

