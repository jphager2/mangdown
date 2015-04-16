module Mangdown
  class Page

    include Equality
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
      return if File.exist?(path = file_path(dir))
      File.open(path, 'wb') { |file| file.write(Tools.get(uri)) }
      FileUtils.mv(path, "#{path}.#{Tools.file_type(path)}")
    rescue SocketError => error
      STDERR.puts( "#{error.message} | #{name} | #{uri}" )
    end

    def file_path(dir)
      Tools.relative_or_absolute_path(dir, name)
    end
  end
end
