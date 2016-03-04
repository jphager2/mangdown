module Mangdown
  class Page

    include Equality

    attr_reader :uri, :name, :manga, :chapter

    def initialize(uri, name, manga, chapter)
      @name = name
      @chapter = chapter
      @manga = manga
      @uri  = Mangdown::Uri.new(uri) 
    end

    # explicit conversion to page 
    def to_page
      self
    end 

    def to_path
      @path ||= set_path
    end

    def set_path(dir = nil)
      dir ||= File.join(manga, chapter)
      dir = Tools.valid_path_name(dir)
      path = File.join(dir, name)
      if Dir.exist?(dir)
        @path = Dir.entries(dir).find { |file| file.to_s[path] }
      end
      @path ||= path
      @path = Tools.valid_path_name(@path)
      @path = Tools.relative_or_absolute_path(@path)
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
      set_path(dir)

      File.open(to_path, 'ab') { |file| file.write(data) } 
    end

    def append_file_ext(dir = nil)
      set_path(dir) if dir
      path = to_path
      ext = Tools.file_type(path)
      filename = "#{path}.#{ext}"

      FileUtils.mv(path, filename)
    end

    def file_exist?(dir = nil)
      set_path(dir) if dir

      File.exist?(to_path)
    end
  end
end
