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

  # downloads to specified directory
  def download_to(dir = Dir.pwd)
    path = dir + '/' + @name
    # don't download again
    return if File.exist?(path)
    File.open(path, 'wb') {|file| file.write(open(uri).read)}
  end
end
