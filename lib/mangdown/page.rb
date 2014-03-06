module Mangdown
  class Page

    attr_reader :info

    # like chapter and manga, should initialize with MDHash, and use
    # @info[:key]
    def initialize(info)
      @info = info
    end

    def filename
      @info[:name]
    end

    def uri 
      @info[:uri]
    end

    # this method should probably be moved somewhere else because
    # pages, chapters and mangas can all be "downloaded"
    def download
      unless File.exist?(@info[:name])
        File.open(@info[:name], 'wb') do |file|
          file.write(open(URI.encode(@info[:uri], '[]')).read)
        end
      end
    end
  end
end
