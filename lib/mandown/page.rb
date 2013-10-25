module Mandown
  class Page
    attr_reader :filename

    def initialize( uri, filename )
      @filename = filename + '.jpg'
      @uri = uri
    end

    def download
      File.open(@filename, 'wb') do |file|
        file.write(open(@uri).read)
      end
    end
  end
end
