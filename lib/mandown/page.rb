require 'open-uri'

module Mandown
  class Page
    attr_reader :filename

    def initialize( uri, filename )
      @filename = filename
      @uri = uri
    end

    def download
      File.open(@filename, 'wb') do |file|
        file.write(open(@uri))
      end
    end
  end
end
