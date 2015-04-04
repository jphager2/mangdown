module Mangdown
	class Properties

		def initialize(uri, site = nil, doc = nil)
      adapter_class = ADAPTERS.find { |adapter| 
        (site||uri).to_s =~ /#{adapter.to_s.split('::').last.downcase}/
      }
      if adapter_class
        @adapter = adapter_class.new(uri, doc)
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
