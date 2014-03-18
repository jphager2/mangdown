module Mangdown
  class Page

    attr_reader :info

    # like chapter and manga, should initialize with MDHash, and use
    # @info[:key]
    def initialize(info)
      @info = info
    end

		# depreciated
    def filename
			puts 'This is depreciated use Page.new.name'
      @info[:name]
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

		private
      # dot access to hash values
			def method_missing(method, *args, &block) 
				return @info[method] if @info[method]
				super
			end

  end
end
