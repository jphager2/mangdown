# frozen_string_literal: true

module Mangdown
  # Mangdown page
  class Page
    include Equality
    include Logging

    attr_reader :uri, :name, :manga, :chapter

    def initialize(uri, name, manga, chapter)
      @name = Tools.valid_path_name(name)
      @chapter = chapter
      @manga = manga
      @uri = CGI.escape(uri)
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
      file = Dir.entries(dir).find { |f| f[name] } if Dir.exist?(dir)
      path = File.join(dir, file || name)
      @path = Tools.relative_or_absolute_path(path)
    end

    # downloads to specified directory
    def download_to(dir = Dir.pwd, force_download: false)
      delete_files!(dir) if opts[:force_download]

      return if file_exist?(dir)

      image = Tools.get(uri)

      append_file_data(dir, image)
      append_file_ext(dir)
    rescue => error
      logger.error({
        msg: 'Failed to download page',
        page: self,
        uri: uri,
        error: error,
        error_msg: error.message,
        backtrace: error.backtrace
      }.to_s)
    end

    def append_file_data(_dir, data)
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

    # cleanup existing file (all extensions)
    def delete_files!(dir)
      File.delete(to_path) while set_path(dir) && File.exist?(to_path)
    end
  end
end
