module Mangdown
  class Page

    include Equality
    attr_reader :name, :uri

    def initialize(name, uri)
      name.gsub!(/_/, ' ') && name.gsub!(/-/, '')
      @name = name.sub(/([^\d])(\d+)(\.\w+)$/) { 
        "#{Regexp.last_match[1]}" +
        "#{Regexp.last_match[2].to_s.rjust(3, '0')}" +
        "#{Regexp.last_match[3]}" 
      }
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
    rescue SocketError => error
      STDERR.puts( "#{error.message} | #{name} | #{uri}" )
    end

    def file_path(dir)
      Tools.relative_or_absolute_path(dir, name)
    end
  end
end
