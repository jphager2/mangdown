module Mangdown
  class Page
    include Equality
    include Logging

    attr_reader :uri, :name, :manga, :chapter

    def initialize(uri, name, manga, chapter)
      @name = Tools.valid_path_name(name)
      @chapter = chapter
      @manga = manga
      @uri = URI.escape(uri) 
    end

    # explicit conversion to page 
    def to_page
      self
    end 

    def to_path
      @path ||= set_path
    end

    # Set path of page to file path if a file exists or to path
    # without file extension if file is not found. File extensions
    # are appended only after the file has been downloaded.
    def set_path(dir = nil)
      dir ||= File.join(manga, chapter)
      dir = Tools.valid_path_name(dir)
      if Dir.exist?(dir)
        file = Dir.entries(dir).find { |file| file[name] }
      end
      path = File.join(dir, file || name)
      @path = Tools.relative_or_absolute_path(path)
    end

    # downloads to specified directory
    def download_to(dir = Dir.pwd, opts = { force_download: false })
      # cleanup existing file (all extensions)
      delete_files!(dir) if opts[:force_download]

      return if file_exist?(dir)
      
      image = Tools.get(uri)

      append_file_data(dir, image)
      append_file_ext(dir)
    rescue => error # SocketError not defined?
      logger.error "#{error.message} | #{name} | #{uri}"
    end

    def append_file_data(dir, data)
      File.open(to_path, 'ab') { |file| file.write(data) } 
    end

    def append_file_ext(dir = nil)
      set_path(dir) if dir
      path = to_path
      ext = Tools.image_extension(path)
      filename = "#{path}.#{ext}"

      FileUtils.mv(path, filename)
    end

    def file_exist?(dir = nil)
      set_path(dir) if dir

      Dir.entries(dir).any? { |file| file.to_s[to_path.basename.to_s] }
    end

    def delete_files!(dir)
      while set_path(dir) && File.exist?(to_path)
        File.delete(to_path)
      end
    end
  end
end
