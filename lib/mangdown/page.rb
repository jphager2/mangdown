module Mangdown
  class Page

    include Equality

    attr_reader :uri, :name

    def initialize(uri, name)
      @name = name
      @uri  = Mangdown::Uri.new(uri) 
    end

    # explicit conversion to page 
    def to_page
      self
    end	

    # downloads to specified directory
    def download_to(dir = Dir.pwd)
      return if file_exist?(dir)
      
      image = Tools.get(uri)

      append_file_data(dir, image)
      append_file_ext(dir)
    rescue => error # SocketError not defined?
      STDERR.puts( "#{error.message} | #{name} | #{uri}" )
    end

    def append_file_data(dir, data)
      path = file_path(dir)

      File.open(path, 'ab') { |file| file.write(data) } 
    end

    def file_path(dir)
      Tools.relative_or_absolute_path(dir, name)
    end

    def append_file_ext(dir)
      path = file_path(dir)
      ext = Tools.file_type(path)
      filename = "#{path}.#{ext}"

      FileUtils.mv(path, filename)
    end

    def file_exist?(dir)
      path = file_path(dir)

      Dir.entries(dir).any? { |file| file.to_s[path.to_s] }
    end
  end
end
