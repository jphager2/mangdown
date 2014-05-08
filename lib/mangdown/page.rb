class Mangdown::Page

	include Mangdown 

	attr_reader :name, :uri

	def initialize(name, uri)
		@name = name
		@uri  = Mangdown::Uri.new(uri) 
	end

	# explicit conversion to page 
	def to_page
		self
	end	

  # download the page
	def download
    # don't download again
		return nil if File.exist?(@name)
    File.open(@name, 'wb') do |file|
			file.write(open(uri).read)
		end
	end
end
