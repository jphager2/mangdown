module Mangdown
	class Properties

		def initialize(uri, site = nil, doc = nil)
      case (site || uri).to_s
      when /mangareader/
				@adapter = Mangareader.new(uri, doc)
      when /mangapanda/ 
				@adapter = Mangapanda.new(uri, doc)
      when /mangafox/
				@adapter = Mangafox.new(uri, doc)
      when /wiemanga/
				@adapter = Wiemanga.new(uri, doc)
      else
        raise ArgumentError, 
          "Bad Site: No Properties Specified for Site <#{uri}>"
      end
		end

    private
    def method_missing(method, *args, &block)
      if @adapter.respond_to?(method)
        @adapter.__send__(method, *args, &block)
      else
        super
      end
    end
	end
end
