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

    def download
      unless File.exist?(@info[:name])
        File.open(@info[:name], 'wb') do |file|
          file.write(open(URI.encode(@info[:uri], '[]')).read)
        end
      end
    end

		private
		  # put this in Mangdown and just add if @info
      # dot access to hash values
			def method_missing(method, *args, &block) 
				return @info[method] unless @info[method].nil?
				super
			end

  end
end
