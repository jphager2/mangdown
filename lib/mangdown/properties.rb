module Mangdown
	class Properties

		def initialize(uri, site = nil, doc = nil, name = nil)
      adapter_class = ADAPTERS.find { |adapter| 
        (site||uri).to_s =~ /#{adapter.to_s.split('::').last.downcase}/
      }
      if adapter_class
        @adapter = adapter_class.new(uri, doc, name)
      else
        error = "Bad Site: No Properties Specified for Site <#{uri}>"
        error << "Params given {uri: #{uri}, site: #{site}, doc: #{doc}, name: #{name}}"
        raise ArgumentError, error
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
