class Mangdown::Page

	include Mangdown 

	attr_reader :name, :uri

	def initialize(name, uri)
		@name = name
		@uri  = Mangdown::Uri.new(uri) 
	end

	def download
		return nil if File.exist?(@name)             # don't download again
		File.open(@name, 'wb') do |file|
			file.write(open(uri).read)
		end
	end
end
