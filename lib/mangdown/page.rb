module Mangdown
  class Page
    attr_reader :filename, :uri

    def initialize( uri, filename )
      @filename = filename + '.jpg'
      @uri = uri
    end

    def download
      File.open(@filename, 'wb') do |file|
        file.write(open(URI.encode(@uri, '[]')).read)
      end
    end
  end
end
