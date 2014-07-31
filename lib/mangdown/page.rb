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
    path = dir + '/' + name
    # don't download again
    return if File.exist?(path)
    image = open(uri).read
    File.open(path, 'wb') {|file| file.write(image)}
  rescue SocketError => error
    STDERR.puts( "#{error.message} | #{name} | #{uri}" )
  end
end
